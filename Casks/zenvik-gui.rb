cask "zenvik-gui" do
  arch arm: "arm64", intel: "amd64"

  version "1.2.1"
  sha256 arm:   "8f745dce1fea8b9df56043fccbe6829d01578dda4c47e78e3f4ae7ed9e51968b",
         intel: "3c0d4e2aba49fd98e9358a263d40ac27fafcdf9b3f4b411e6d1175c24d7f190c"

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
