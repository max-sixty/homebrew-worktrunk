# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.15"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.15/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "2d56549931bfa4e12906a74ad79f926dc983842c16ea4b2d74a4451c04a46e3d"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.15/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "0d4c25382e816fef046763fb86f71e1a37feaf9e37b2885f79f6b9c6edfb1887"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.15/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e48c49de4730ade2abe9a70650132c9b859fc1cd4b538b32a9893427edffe267"
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
