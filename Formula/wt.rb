# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.8.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "2e6f724a9fcceb2b014127a39260e72b8fc9052863816be6435f0a57d0cc2af3"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "7f65c1f726d99c4b77a871143578ba5b02f927769f830d8270b206c97a5841f9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8f1ee6a2f61ec03852737322523c8e314c6fe728dd1ca11efe2f0c313973caf1"
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
