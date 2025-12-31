# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.8.2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.2/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "53412c33cc2a73e8ec4d1de9858c652027412877ec963cb817df21109c495bb4"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.2/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "3db1ea2991e181bf6147186754ac3f9cc5cca2870ed797b143022329bc1c149a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.2/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4179691bfceae3b267e34b2e4d54872fa62d59a69d237fbe5d64029ab4d7be45"
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
