# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.7.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.7.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "8e6ba023f24b8a6e015059276dfa96928cf543b83bca5f1384de10f519f89163"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.7.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "516676f6fe2b77c5aeb59c6cc3e08d1f9b21ea02962a9b1808817b8ceba0d94e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.7.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2b896ce7872076448daae77779c6295a7c0abfb43fcc16c8ef33a8984de9acc8"
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
