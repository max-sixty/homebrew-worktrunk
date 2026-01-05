# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.9.3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.3/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "a4f171632a7a834d439d19c36ef68e5f73bc6ef7c2bca7e98faaf52d545d18eb"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.3/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "8466130191051638380055a91639d6542ed8ceafe38fdc1a3839fcf6b1cb3f60"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.3/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3ae3f4b3ae856a608b4c7cda3bece77f67275df777e6abb0f0455ca14c8e9dc1"
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
