# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.4.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.4.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "bdbc6d5aa5bf2cdf4965af2025dbfe00f648a34121d09c73203bc5d1348acd44"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.4.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "f698051e2b8e65315b2ba29ed6dc196db43137c1a0ca536eeb5b41ce228ff535"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.4.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a82f7d8a10a1c922faa3f1a872a61e839649d80a1c9ef4247a859c550d6d3e71"
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
