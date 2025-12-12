# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.2.1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.2.1/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "b427fbb4565b685760d61609406919dc176e4f076ff2982c7db0e7b6ccd5f7c3"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.2.1/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "c09c8c0618ed4a2fbee492ebec4a549772fdae2dd086f27892c79e4c5b79d4e7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.2.1/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "72684616ed7e12a500eca30984f4ccfe93fe96d2310ca269f274f0064d03cc29"
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
