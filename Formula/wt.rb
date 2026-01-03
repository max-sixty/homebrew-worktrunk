# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.9.1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.1/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "915915e6be89826c5110aee86d1412e40c332a4e36b95e2099d4d4da28a85e6d"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.1/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "485ae7d27ad56d7e50242f381caf8429b1e2c3375362246962dee7e776bf41e6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.1/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7fbdc7ece52c6811b8921963374ed9b9944007d144375d86172f1995d714e07b"
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
