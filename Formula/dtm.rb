class Dtm < Formula
  desc "Open-source DevOps toolchain manager (DTM)"
  homepage "https://github.com/devstream-io/devstream"
  url "https://github.com/devstream-io/devstream/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f55407dd511734ce59278f867e854bf2b390217c05f3b0261f711a2fb375572d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/devstream-io/homebrew-devstream/releases/download/dtm-0.4.0"
    sha256 cellar: :any_skip_relocation, big_sur:      "a1dcf23c10b4d6cff24b41db595dab1cb54fe7702e7529baa4f7c5a3c6535321"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "33044d6899336d8fc91c575d00157c25df0f24038297c822da620cc94dbcfff9"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    mkdir_p buildpath/"bin"
    ENV.prepend_path "PATH", buildpath/"bin"
    (buildpath/"src/github.com/devstream-io/devstream").install buildpath.children
    cd "src/github.com/devstream-io/devstream" do
      system "make", "build-core"
      mv "dtm-#{goos}-#{goarch}", "dtm"
      bin.install "dtm"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtm version")
  end
end
