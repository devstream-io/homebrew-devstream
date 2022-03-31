class Dtm < Formula
  desc "Open-source DevOps toolchain manager (DTM)"
  homepage "https://github.com/merico-dev/stream"
  url "https://github.com/merico-dev/stream/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3223ff4ea46626d6849831ad9abfa6f67699731fd927fe477ab945b3ab9424eb"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/devstream-io/homebrew-devstream/releases/download/dtm-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa62912af71d857e7629ea94988ad528ce3ddf9203cb01527651c0d1bcb6b7c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e03e1695739fa35cf4b27a3baa02486ca92374ca773a29380239b6f1c460929a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644b43d0cfcdd56c70bfe911147a47492526da0bf09c5d3507ae676fe16aace3"
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
