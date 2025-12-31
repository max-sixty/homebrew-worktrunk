# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.8.1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.1/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "adf4a34ac32deeeff35072715b2c57bf8f23b28fc0fe1e15f2486241aaf7db99"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.1/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "6ed0278672f3087546c176e822a758acd353c446b655ccaed9323f14de46097c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.1/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "87dc090d52d66beb0ecbf29e47d2ba135ec6ca961cd110e8aa172e31251de7cc"
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
