# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.8.3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.3/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "6cbfb70dc84d4703857ea889e1abb987b3d83eeb39a2419b1b8b1bdde09fea6e"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.3/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "23169ae5c39f5b7656e81bcdbcdf375f804b839c8a961e48d1a6da1814650ae7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.8.3/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c37ed71733c67082f0f1e6869d2c54a69d9f106ec1fbd0d87c48149514e73d5f"
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
