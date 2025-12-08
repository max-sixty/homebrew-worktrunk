# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.14"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.14/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "72c16cb2b7ff73adb2afeb025f646480a30ddfdb5f059fcb6e2e8bba87f54ca8"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.14/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "ce5302fd0c7655b366c0a306a408709468f94f40b6b91306d0307553cdc55569"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.14/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "43edaf74f3bbd0a6f36083d1057dc2dd9e457a3b22352e7fe411edf7c8107ca9"
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
