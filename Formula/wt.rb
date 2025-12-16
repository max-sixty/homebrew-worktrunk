# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.5.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "5bd54e91c8763b1e8578484c2a6ea8591edf7d269dcf9edfca044e17aa9e3949"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "98185ba8e5cd7ae70e1678fb5b5975e3e67cfa44c650e5803ebc87bef2b0893d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a0af4fcb89f621fa82565ed3d6d32ad9255b9e3df924871a1f8474f5fe56e3b6"
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
