# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.6.1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.6.1/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "8d8ff56e4722d0bb2f30f4c13150f59c506836d31d86f49d06740c413067fc03"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.6.1/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "a348ac2df3baa840d3ee41e0c4ab949c06ef63e2184f766c4d456262c5ebdc67"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.6.1/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0f71aca4ec7a768c484624b889a4a0aef154b97df413b4cab9bf1082834d249b"
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
