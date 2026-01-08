# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.10.0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.10.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "b020cce85917bf31d42284a3a10762eff2e8c0f9f61def5f2ad188a2f89057e5"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.10.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "eefea874eb7ba2ca097bda3abd38b32a56ac08c132b8f1717aee2a4839260839"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.10.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "caafdf8ff1eb66ffa5099c21d513a8aaabef3112fca75c4751b52b9ba65bd530"
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
