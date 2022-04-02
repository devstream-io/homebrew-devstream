class Dtm < Formula
  desc "Open-source DevOps toolchain manager (DTM)"
  homepage "https://github.com/merico-dev/stream"
  url "https://github.com/devstream-io/devstream/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "4dbf0fe6467fd5836fda8e228b715352628e82eff37eb171ceecd5ab68a99bad"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/devstream-io/homebrew-devstream/releases/download/dtm-0.3.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea871b6a5c32ea248d080853f9564b903817d42362f33f1bfa66c64e60d64865"
    sha256 cellar: :any_skip_relocation, big_sur:        "82b7c8080e4739ac455ddcdf2e0e3cbf4a5cb85117cd2f5def4b77cc0fb33924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0877c924920ece9a1bdba498ec4257933c1749defbb15aeeb698c17b75f4beab"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    mkdir_p buildpath/"bin"
    ENV.prepend_path "PATH", buildpath/"bin"
    (buildpath/"src/github.com/merico-dev/stream").install buildpath.children
    cd "src/github.com/merico-dev/stream" do
      system "make", "build-core"
      mv "dtm-#{goos}-#{goarch}", "dtm"
      bin.install "dtm"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtm version")
  end
end
