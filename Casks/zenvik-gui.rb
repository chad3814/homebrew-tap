cask "zenvik-gui" do
  arch arm: "arm64", intel: "amd64"

  version "1.2.0"
  sha256 arm:   "9618e6437cc1a0e1a0332abfd6646cf6fd181547f13744853e5f59c73ace35a9",
         intel: "0e4d3f4ef3a364b893dda6e6b2a5d7ee5d2278b36e707677a7c8abc84adc24fd"

  url "https://github.com/chad3814/zenvik/releases/download/v#{version}/zenvik-gui_#{version}_darwin_#{arch}.dmg"
  name "Zenvik"
  desc "Desktop app to remux Blu-ray and DVD disc images to MKV"
  homepage "https://github.com/chad3814/zenvik"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Zenvik.app"

  zap trash: [
    "~/Library/Caches/dev.cwalker.zenvik",
    "~/Library/Caches/zenvik/gui-queue.json",
    "~/Library/HTTPStorages/dev.cwalker.zenvik",
    "~/Library/Preferences/dev.cwalker.zenvik.plist",
    "~/Library/Saved Application State/dev.cwalker.zenvik.savedState",
    "~/Library/WebKit/dev.cwalker.zenvik",
  ]
end
