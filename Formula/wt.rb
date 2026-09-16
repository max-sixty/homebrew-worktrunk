class Wt < Formula
  desc "A CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  version "0.78.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.78.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "6f7a04e5391a9ff9065c31ef3ca41e2082ccd3aa3cf62c30dd45e2c607effed8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.78.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "644236a05bdc9297b00f7a6b6aa8c4000d9ebca7754df54c805124bda7c90b7f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.78.0/worktrunk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0bf9c0005c8212160809f9ffbe9ef576dd86e96b56c2d541941cfbcb4acb93e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.78.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f365db63805a75a76bed7a84c8bde7e8c27a248e23f9aeb9576eccba3f1d72de"
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
