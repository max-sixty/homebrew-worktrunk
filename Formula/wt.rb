class Wt < Formula
  desc "A CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  version "0.69.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.69.1/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "ad05a0b136cbe693e3de9c2c363b380cd1c34d5c3a5cbd5631438f70025ea01d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.69.1/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "1d4eec602dc826f51105fdb3cf063ca4842bce944a776e599aa7f5f81515413e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.69.1/worktrunk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "037774866895b7a7858e652c17e0c457937bc668726f390d100d9dfc2d947fb7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.69.1/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3e5bbd3036f7a7d57a2456e7c72ae8cbc53e99c8823a0f9245d30151e9a09df8"
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
