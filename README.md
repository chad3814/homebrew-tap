# chad3814/homebrew-tap

Homebrew formulae and casks for [zenvik](https://github.com/chad3814/zenvik), which remuxes Blu-ray and DVD disc images to MKV.

```sh
brew install chad3814/tap/zenvik              # the zenvik command-line tool
brew install --cask chad3814/tap/zenvik-gui   # the Zenvik desktop app (macOS 13+)
```

Installing by the full name, as above, also trusts that formula or cask, which Homebrew 6 and later require for packages from taps it doesn't run itself.

- `zenvik` builds from source and installs [MKVToolNix](https://mkvtoolnix.download) (for `mkvmerge`) with it. It works on macOS and Linux.
- `zenvik-gui` installs the signed, notarized `Zenvik.app` from the release's disk image. The app includes its own `mkvmerge`.

zenvik's release workflow updates these files on every release, after `check.sh` has proved they install. To check by hand: `./check.sh` (macOS), or `./check.sh --formula-only` (Linux).
