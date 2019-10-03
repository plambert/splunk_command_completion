class SplunkBashCompletion < Formula
  desc "Completion for Atom Package Manager"
  homepage "https://github.com/plambert/splunk_command_completion"
  url "https://github.com/plambert/splunk_command_completion/archive/v1.0.1.tar.gz"
  # url "https://github.com/vigo/apm-bash-completion/archive/1.0.0.tar.gz"
  sha256 "533e3876d838bedbc4e5eaac6ff3c3b5ec214779b0b0b5145cdb61deab670c9c"

  bottle :unneeded

  def install
    bash_completion.install "splunk"
  end

  test do
    assert_match "-F fSplunkComplete",
      shell_output("source #{bash_completion}/splunk && complete -p splunk")
  end
end
