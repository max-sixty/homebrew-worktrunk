# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.11.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.11.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "305a6d94af52879ae7a4f8379c43b73a27317e16ab800961c8740ef5506794d1"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.11.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "3df002e9b3243b70a71bf257b4c5b5626b37e8c032373eef319d37616241fc79"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.11.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e839ad08aac38240961ecb471ce90a2da9ff7525f41b08ab1a87d7d8235fbe98"
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
