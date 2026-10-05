class Zenvik < Formula
  desc "Remux Blu-ray and DVD disc images to MKV"
  homepage "https://github.com/chad3814/zenvik"
  url "https://github.com/chad3814/zenvik/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "345102b729cb8e4b637e29d1962bc239b0d79b39a50793bc474fd3299d711b61"
  license "MIT"
  head "https://github.com/chad3814/zenvik.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on "mkvtoolnix"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/zenvik"
  end

  test do
    assert_match "zenvik v#{version}", shell_output("#{bin}/zenvik --version")
    assert_match "no such file", shell_output("#{bin}/zenvik info #{testpath}/missing.iso 2>&1", 1)
  end
end
