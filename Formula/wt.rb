# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.9.4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.4/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "8ae2c26489a6aedb480b46fc896e3b8c3894e3b8410721b8d0d7643395f6b407"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.4/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "eb3c228d73fe775d1f9fa8c78e54325cc010f029b958544b347e23e0426b4bcf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.9.4/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f86da18eeb2c4b9ccf7a1ea8e0e7663e70949172a58ae53d5fc60cb4aa146257"
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
