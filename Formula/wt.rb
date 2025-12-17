# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.5.1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.1/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "ef5ee85b995f407c2e76f0ef3832b80fbd11a534d315b2319a8c8c64e99d8f73"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.1/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "8880a6332d9bb094f3098fe6e46a546b97a27c2ffbe3f92bd10bd02d83320d81"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.1/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "297b2e3dccb1e6efb30c94ef4faebec136f257a0dbf037b8a03302d03730895f"
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
