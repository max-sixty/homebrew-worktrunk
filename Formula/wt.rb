# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.3.1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.3.1/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "91beeff91b60f37962c91269abf483041725da2789815b857d594e547b52d454"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.3.1/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "49f30275a86861aeed6e7ccdcd02e657297a09e9ce854ec089604ce7f41745cb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.3.1/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "441cf18126a03cb9884530793a5f9ea9920e8b5627306634b7d47bd8c8315b43"
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
