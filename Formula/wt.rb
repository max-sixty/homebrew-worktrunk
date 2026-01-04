# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.9.2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.2/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "8ced38da6dc5109fb7fe89a2a55c18869b8f61c25432eca9347941eda0775ddd"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.2/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "84e1f068c4a0a6c2131f849ef508ec7fe6f18b72524cd0615ec2623d54769a58"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.2/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c72776ea26bee8f64201dbd29885bcb396fdb5d1688a5c056dfbabcad5033372"
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
