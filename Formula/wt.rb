# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.19"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.19/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "6e5d4d83c0ab79444e2600148909c7b3887cc109dc6b2660cced9406798f1a9d"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.19/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "848dd873fe5e890ecb2ef109c1b3bfa911da356bf6ea4e1bba28befbd873e521"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.19/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "19244876f55663d17d584d05b747d51d250bb892cf5861a119c0c99871171470"
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
