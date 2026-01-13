# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.13.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.13.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "b039d788aef109bb6ee48c6c1cc996497e5d90de9c201b21bb17e4091e51abea"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.13.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "410ef9e785eab230b2dcffc036d88cd6f9f2d16945a9ce8d8924e5bc01155075"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.13.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2bfb1b24b4479ae6bb53d748ad6b1080d8498d18aa51ae23dfe69473a304505e"
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
