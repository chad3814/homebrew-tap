class Zenvik < Formula
  desc "Remux Blu-ray and DVD disc images to MKV"
  homepage "https://github.com/chad3814/zenvik"
  url "https://github.com/chad3814/zenvik/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9168aa068131ec1555514e106649cd73dbf3f6e3e8be8121cb737d048e6604a8"
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
