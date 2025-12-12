# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.21"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.21/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "38f37524d7a7a8f2261a49cbff75af0e68809aed6e39993279844371380f75dd"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.21/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "267e20355d230aa092e6ab8b638366d0ab7b49330ad8a028e67f863901dbe335"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.21/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "db8f7dc2b4d6623068c937854e0b3921c5328b254276621fefd859689bfb3b49"
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
