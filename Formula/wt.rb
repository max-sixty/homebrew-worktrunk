class Wt < Formula
  desc "A CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.20.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "5ecf65efda4c70fbfa15be36d01e6c61bd68cc75836e000beea4f759a6c905e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.20.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "a248ae6971ae6068711239e11367c477cbc86f83c8abde695e9eec3e2dce9b86"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.20.0/worktrunk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "79c0e867e41687bd339809cb7d26fd5d4728c3b3ccdba2791b575f82403442b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.20.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "934c49d481c9fcf276995ac01a904a2bf8e82497eba6fa34118d97862736711a"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "git-wt", "wt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-wt", "wt"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-wt", "wt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-wt", "wt"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
