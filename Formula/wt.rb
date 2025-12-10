# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://github.com/max-sixty/worktrunk"
  version "0.1.17"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.17/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "e31dae8dec61cb9a5ab33f07cd17c8f2801734fc8a5008c6fc284f2fe8988ad3"
    end
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.17/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "09651d9d96da5a475899a9bd445d3b9fa509c706d7be2be007740e894a6783bc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.1.17/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "95244589df9499bfa35cdbccd2e683abb828923c912854ba47f74de70b5192d0"
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
