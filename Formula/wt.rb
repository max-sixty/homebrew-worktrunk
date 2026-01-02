# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.8.4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.4/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "24b7a0c74972b6e0e2d256ab3f110f7fede70ec73acf7176e43024909c987783"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.4/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "e0f2d65c7f4891df95b7db4894f6425802ca0e8733d26aaa169d9cf000c270d8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.4/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "fcc700da843ab4659750dc0df53871fef2f1c92cc1d916ad41f09ac96e154819"
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
