# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.18"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.18/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "f3c7fd50404c20f49e8995aa4ac3ea7a3c8d45be8a42859e362830bfc8ff6d2b"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.18/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "f319e590ac000dbf5a8dd2039a58cc1a886a4493468f875fb6700cea47153c87"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.18/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "84530012e470874eb89f57d5183814afeeb575cca5d98b21583fd56f2b488672"
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
