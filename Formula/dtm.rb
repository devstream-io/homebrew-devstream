class Dtm < Formula
  desc "Open-source DevOps toolchain manager (DTM)"
  homepage "https://github.com/merico-dev/stream"
  license "Apache-2.0"
  url "https://github.com/merico-dev/stream/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3223ff4ea46626d6849831ad9abfa6f67699731fd927fe477ab945b3ab9424eb"

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
