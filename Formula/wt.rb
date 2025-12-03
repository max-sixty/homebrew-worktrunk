# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.12"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.12/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "8a46a28cbd43bd8085e834fd6a00ce10f773f9a403e4641f78e942e71c08d4c5"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.12/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "bdc2df81754791fb908dcf410094e04b4e6a603d99c30bf97308fcbad0866f33"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.12/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c0fdc2d9dea6917e7c2195efb2e62f7368d29f4c61445a5e80a39715cb724468"
    end
  end

  def install
    bin.install "wt"
  end

  def caveats
    <<~EOS
      To enable shell integration (directory switching, completions), run:

        wt config shell install
    EOS
  end

  test do
    assert_match "wt v#{version}", shell_output("#{bin}/wt --version 2>&1")

    # Test basic functionality in a git repo
    system "git", "init", "test-repo"
    cd "test-repo" do
      system "git", "config", "user.email", "test@test.com"
      system "git", "config", "user.name", "Test"
      system "git", "commit", "--allow-empty", "-m", "init"
      # wt list outputs to stderr in interactive mode, verify via JSON
      output = shell_output("#{bin}/wt list --format=json")
      assert_match '"branch":', output
    end
  end
end
