cask "zenvik-gui" do
  arch arm: "arm64", intel: "amd64"

  version "1.1.2"
  sha256 arm:   "03f6d254abe5bbe98c0978f15e61260fd670a744046a58d92b7b83c09b442f21",
         intel: "c98cf9636cd27e1ba49955889bb8c1d9281c592643d80f1deecb3ee2f460fd6c"

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
