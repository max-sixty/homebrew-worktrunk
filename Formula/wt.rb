class Wt < Formula
  desc "A CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  version "0.63.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.63.0/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "32dc3321758dacc9588e27aa1a36f9543c5d22f3fded8f4519a9636271ccbbd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.63.0/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "3ef9f78f8bcb9c00e9012a99b6bc30bac11ae857529063f69d107bb0a8ff0516"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.63.0/worktrunk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1b6bfc692c28786e7355fad65ce14d4203719639c41dfd57edda72e385f36bea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.63.0/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8d8b4bf79bd764943b3cb85c1e548b233c4f51548bb5974e3770459e16093239"
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
