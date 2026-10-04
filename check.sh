#!/usr/bin/env bash
# Prove this tap's formula and cask install and work. CI runs it on every
# push; zenvik's release workflow runs it on a freshly rendered bump before
# pushing that bump here.
#
#   ./check.sh                 # formula, and in CI the cask (macOS)
#   ./check.sh --formula-only  # formula only (Linux)
#   ./check.sh --with-cask     # formula and cask, outside CI too
#
# The cask half installs Zenvik.app into /Applications and then uninstalls it
# with --zap, which deletes the app's settings and saved queue. So on your
# own Mac it only runs when asked for.
#
# It links this checkout in as the chad3814/tap tap (so the files on disk,
# committed or not, are what's checked), then audits, installs and tests.
set -Eeuo pipefail

cask=0
[[ ${CI:-} == true ]] && cask=1
case ${1:-} in
"") ;;
--formula-only) cask=0 ;;
--with-cask) cask=1 ;;
*)
	echo "usage: $0 [--formula-only | --with-cask]" >&2
	exit 2
	;;
esac

here=$(cd "$(dirname "$0")" && pwd -P)
current=setup
step() {
	current=$*
	echo "==> $*"
}
trap 'echo "check.sh: failed at: $current" >&2' ERR
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1

step "link $here as chad3814/tap"
taps="$(brew --repository)/Library/Taps/chad3814"
link="$taps/homebrew-tap"
if [[ -e $link || -L $link ]]; then
	if [[ $(cd "$link" 2>/dev/null && pwd -P) == "$here" ]]; then
		: # already this checkout (setup-homebrew links the repo it runs in)
	elif [[ -L $link ]]; then
		rm "$link"
	else
		echo "check.sh: $link is a real tap, not a link; run \`brew untap chad3814/tap\` first" >&2
		exit 1
	fi
fi
if [[ ! -e $link ]]; then
	mkdir -p "$taps"
	ln -s "$here" "$link"
fi

# Homebrew 6+ loads non-official taps only when trusted. Users get this by
# installing the full name (brew install chad3814/tap/zenvik); audit, style
# and test need it granted first.
step "trust the zenvik formula and zenvik-gui cask"
brew trust --formula chad3814/tap/zenvik
brew trust --cask chad3814/tap/zenvik-gui

# Only the formula and cask: styling the whole tap would also format check.sh
# and lint the workflows, installing shfmt and actionlint to do it.
step "brew style"
brew style --formula chad3814/tap/zenvik
brew style --cask chad3814/tap/zenvik-gui

step "audit the zenvik formula"
brew audit --strict --online --formula chad3814/tap/zenvik
step "install the zenvik formula from source"
brew install --build-from-source chad3814/tap/zenvik
step "test the zenvik formula"
brew test chad3814/tap/zenvik

if [[ $cask == 1 ]]; then
	step "audit the zenvik-gui cask"
	brew audit --strict --online --cask chad3814/tap/zenvik-gui
	step "install the zenvik-gui cask"
	brew install --cask chad3814/tap/zenvik-gui
	app=/Applications/Zenvik.app
	step "Gatekeeper accepts $app"
	out=$(spctl -a -vv -t exec "$app" 2>&1 || true)
	if ! grep -q 'source=Notarized Developer ID' <<<"$out"; then
		echo "$out" >&2
		false
	fi
	step "the app's bundled mkvmerge runs"
	out=$("$app/Contents/Helpers/mkvmerge" --version 2>&1)
	if [[ $out != "mkvmerge v"* ]]; then
		echo "$out" >&2
		false
	fi
	step "uninstall the zenvik-gui cask with --zap"
	brew uninstall --cask --zap chad3814/tap/zenvik-gui
elif [[ ${1:-} != --formula-only ]]; then
	echo "check.sh: skipped the zenvik-gui cask outside CI (it would replace /Applications/Zenvik.app and --zap its data); pass --with-cask to include it"
fi

echo "check.sh: all checks passed"
