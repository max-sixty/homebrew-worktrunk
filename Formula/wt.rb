# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.3.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.3.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "d6127dac65e734e67bbbcc34665b205592f7f3ec0d4b813b154301116f32334e"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.3.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "d684d80f053469491d4b4207ed860a3e415707b8992a2841be1bdd901ff42230"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.3.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6b7cd6d9dd328b6f1f43bc419002f0d6aaa8554a5eb92a0991e7d47ca921130d"
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
