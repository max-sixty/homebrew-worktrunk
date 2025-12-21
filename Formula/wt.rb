# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.6.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.6.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "c6c4344add8ef63c1c8bde44a5abde9dcc0a50c84f163faf88bbfaeb891406bf"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.6.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "5756e93292a44cf44d15a2aba342a332f8d5f4975c98c04a3a536a1d2bc24115"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.6.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5a2699c09c974a6f105453509f21892588e6e605adb37be5d12100761ab8f1e9"
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
