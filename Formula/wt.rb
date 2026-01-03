# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.9.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "451ab547fafc6c89884576ceb9b4c931893d63a0e5649b8dfe1286feb650d71d"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "2f6f0df4646cdcde475d27f27d606ae3f80a177565c5301c3aa4cc874cfd1627"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d471041b1d425cab52341d65ebb1a29c627f279efe865de76ab46cb1e7f2ef97"
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
