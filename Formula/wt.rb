# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.20"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.20/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "6276f26b47ab62e5416c6c3ed57ff93fe0fe3fab1eedcfefc079790b847e8457"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.20/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "5c797f650e6d9a90efb58b17232064da09d7743fe206df98a6fb13097b84adfa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.20/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bb344ec9222906e634d49dbad33c0bc3bae2b4665e06afcf6e11e756c53b83cc"
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
