class Dtm < Formula
  desc "Open-source DevOps toolchain manager (DTM)"
  homepage "https://github.com/merico-dev/stream"
  url "https://github.com/devstream-io/devstream/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "4dbf0fe6467fd5836fda8e228b715352628e82eff37eb171ceecd5ab68a99bad"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/devstream-io/homebrew-devstream/releases/download/dtm-0.3.2"
    sha256 cellar: :any_skip_relocation, big_sur:      "6f8dd051d400678783cd16db58dbe8d4da2fc608fe13965c206fa0a4a3a637e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43010819b624f95e52920e48dfd4dfa68d129d291ee3b190486460d2dba30315"
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
