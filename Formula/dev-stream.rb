class DevStream < Formula
  desc "DevStream: the open-source DevOps toolchain manager (DTM)."
  homepage ""
  url "https://github.com/merico-dev/stream/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3223ff4ea46626d6849831ad9abfa6f67699731fd927fe477ab945b3ab9424eb"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV.prepend_path "PATH", buildpath/"bin"
    (buildpath/"src/github.com/merico-dev/stream").install buildpath.children
    cd "src/github.com/merico-dev/stream" do
      system "make", "build"
      system "mv", "dtm-#{goos}-#{goarch}", "dtm"
      bin.install "dtm"
    end
  end

  test do
    system "false"
  end
end
