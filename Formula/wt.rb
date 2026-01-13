# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.13.2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.13.2/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "baa821a71052463e5deb3185c6079128ce21df21f13b95184aa58ed3feeeeae6"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.13.2/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "0cbfbd02bf22cd9fc7df303ba00797ff7c6b356cc2935be3017d50cba5dbc0c5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.13.2/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "87e6da0f631863ff7dea4426d8dfdcf7ca9fe3a22072a10cc41454172309e1cd"
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
