# typed: false
# frozen_string_literal: true

class Wt < Formula
  desc "Git worktree manager for trunk-based development"
  homepage "https://github.com/max-sixty/worktrunk"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "5545d62a6ec7d13fc810675601ded68ca1d7ddc5d710a1886f71133922d2d8d9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      To enable shell integration (directory switching, completions), run:
        wt configure-shell

      Or manually add to your shell config:
        Bash: eval "$(wt init bash)"
        Zsh:  eval "$(wt init zsh)"
        Fish: wt init fish | source
    EOS
  end

  test do
    assert_match "wt #{version}", shell_output("#{bin}/wt --version")

    # Test basic functionality in a git repo
    system "git", "init", "test-repo"
    cd "test-repo" do
      system "git", "config", "user.email", "test@test.com"
      system "git", "config", "user.name", "Test"
      system "git", "commit", "--allow-empty", "-m", "init"
      # wt list outputs to stderr in interactive mode, verify via JSON
      output = shell_output("#{bin}/wt list --format=json")
      assert_match "worktrees", output
    end
  end
end
