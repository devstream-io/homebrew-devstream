class Dtm < Formula
  desc "Open-source DevOps toolchain manager (DTM)"
  homepage "https://github.com/merico-dev/stream"
  url "https://github.com/merico-dev/stream/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3223ff4ea46626d6849831ad9abfa6f67699731fd927fe477ab945b3ab9424eb"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/devstream-io/homebrew-devstream/releases/download/dtm-0.3.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "4ac4d32be3ef71a14d12613c82f36e15dc9977ed7f2799e5413be2338ea9d40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "23345a92a02901ba8c8c1b5298125c0d8e705d407a6f37cb578be478c4fa9824"
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
