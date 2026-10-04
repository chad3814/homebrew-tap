#!/usr/bin/env bash
# Tests for check.sh's choice of what to run, against a stand-in `brew` that
# only logs its arguments (nothing is installed).
#
#   test/check_test.sh
set -uo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
pass=0
fail=0
ok() { pass=$((pass + 1)); echo "ok   $1"; }
bad() { fail=$((fail + 1)); echo "FAIL $1"; [[ -n ${2:-} ]] && echo "     $2"; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin" "$work/brew-repo"
cat >"$work/bin/brew" <<STUB
#!/usr/bin/env bash
if [[ \$1 == --repository ]]; then echo "$work/brew-repo"; exit 0; fi
echo "brew \$*" >>"$work/log"
STUB
chmod +x "$work/bin/brew"

# run NAME CI_VALUE ARGS...: run check.sh, leaving the brew log in $log
run() {
	local ci=$2
	shift 2
	rm -f "$work/log"
	out=$(env PATH="$work/bin:$PATH" CI="$ci" "$root/check.sh" "$@" 2>&1)
	log=$(cat "$work/log" 2>/dev/null)
}

run "local" "" 
if [[ $log == *"install --build-from-source chad3814/tap/zenvik"* && $log != *"install --cask"* && $log != *zap* ]]; then
	ok "outside CI the cask is skipped (no install, no --zap)"
else
	bad "outside CI the cask is skipped (no install, no --zap)" "$log"
fi
if [[ $out == *--with-cask* ]]; then ok "outside CI it says how to include the cask"; else bad "outside CI it says how to include the cask" "$out"; fi

run "ci" true
if [[ $log == *"install --cask chad3814/tap/zenvik-gui"* ]]; then ok "in CI the cask is installed"; else bad "in CI the cask is installed" "$log"; fi

run "local opt-in" "" --with-cask
if [[ $log == *"install --cask chad3814/tap/zenvik-gui"* ]]; then ok "--with-cask runs the cask outside CI"; else bad "--with-cask runs the cask outside CI" "$log"; fi

run "formula only in CI" true --formula-only
if [[ $log != *"install --cask"* && $log == *"test chad3814/tap/zenvik"* ]]; then ok "--formula-only skips the cask even in CI"; else bad "--formula-only skips the cask even in CI" "$log"; fi

if "$root/check.sh" --bogus >/dev/null 2>&1; then bad "an unknown option is a usage error"; else ok "an unknown option is a usage error"; fi

echo "$pass passed, $fail failed"
[[ $fail -eq 0 ]]
