class Cw < Formula
  version = "1.1.0"
  
  desc "CloudWatch Log CLI Tool"
  homepage "https://github.com/lucagrulla/cw"
  url "https://github.com/lucagrulla/cw.git",
        :tag => version
  head "https://github.com/lucagrulla/cw.git"

  depends_on "go" => :build
  
  bottle do
    root_url "https://github.com/lucagrulla/homebrew-cw/releases/download/#{version}"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8d2afd3a14288d5b44130c897f6edce1da4230df51ac0a8d25461f4cfdf1acf" => :sierra
  end

  def install
    ENV["GOPATH"] = buildpath
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    dir = buildpath/"src/github.com/lucagrulla/cw"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Make binary
      system "go", "build", "-o", "cw"
      bin.install "cw"

      # Install bash completion
      output = Utils.popen_read("#{bin}/cw completion bash")
      (bash_completion/"cw").write output
      
      # Install zsh completion
      output = Utils.popen_read("#{bin}/cw completion zsh")
      (zsh_completion/"cw").write output
    end
  end
  
  def caveats
      <<-EOS.undent
      
      In order to get cw completion, 
        [bash] you need to install `bash-completion` with brew.
        OR
        [zsh], add the following line to your ~/.zshrc:
          source #{HOMEBREW_PREFIX}/share/zsh/site-functions/_cw
      EOS
  end

  test do
    run_output = shell_output("#{bin}/cw --help 2>&1")
    assert_match "cw is a CLI tool to interact with your CloudWatch log streams", run_output
  end
end