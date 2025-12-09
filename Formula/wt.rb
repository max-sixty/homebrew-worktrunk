# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.16"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.16/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "00fe799bca3a74f6ab4339e25b59840eb071d9aa5cf1609de79840fc1462db46"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.16/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "a7c1d34b0caad6f377bd1d544e1497a33f40850bb46c08d18269e4c4333d305f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.16/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6e5382e7113fbcd40307814896ff21b37912e0853e6fc3c5eefd4fab54576136"
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
