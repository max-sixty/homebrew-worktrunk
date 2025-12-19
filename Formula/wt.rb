# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.5.2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.2/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "e3c0b7a6c2e418b9c6323bc6f4dd025a5f46214af249834425cd353d5ba8bcd0"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.2/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "470e037a53ccd5f25f3ae282a4b15d9be9d2792f8cd393f88c7ee2db23864991"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.5.2/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4501bd605c8badd43a60f26fb4e1c9888efd63552aeccd05f79f458fb7b1cce2"
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
