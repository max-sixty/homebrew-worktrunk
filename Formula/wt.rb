# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.11"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.11/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "66ee656bba366a19b412e60671b5b60d59beb8412f526491fa0d9fc5319eb05d"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.11/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "f7a4df37661584b0e5451cac3947d06434e5fcc2bb5abe7e8739c8d1f75f0dc6"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
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
