# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.8.5"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.5/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "3703cbba0dd87e33540ba4a6be6a373120f1d241ec4f3ae3c54867a8f5755098"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.5/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "f4dc77cb30667c64e58b5a6f6eb8f528a78aebec8ac955d725390909e3f0fecf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.5/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f1b320a9ccf983294c9e2819b64098c8ffb94732799ba50f4ac475f817ceedbc"
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
