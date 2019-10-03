class SplunkBashCompletion < Formula
  desc "Completion for Atom Package Manager"
  homepage "https://github.com/plambert/splunk_command_completion"
  url "https://github.com/plambert/splunk_command_completion/archive/v1.0.2.tar.gz"
  sha256 "4e4d5ab517978f096d0ed1b84525b124fafecd4567478db19b882de45413ce6a"

  bottle :unneeded

  def install
    bash_completion.install "splunk"
  end

  test do
    assert_match "-F fSplunkComplete",
      shell_output("source #{bash_completion}/splunk && complete -p splunk")
  end
end
