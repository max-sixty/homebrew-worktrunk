class Wt < Formula
  desc "A CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  version "0.34.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.34.2/worktrunk-aarch64-apple-darwin.tar.xz"
      sha256 "fd045796c620d15f650732e14c044ebf0cec59d59044a52e4d67a44f053921ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.34.2/worktrunk-x86_64-apple-darwin.tar.xz"
      sha256 "ab4178da3b3db84e1c7f47c4189d8a8a742ad689e679d54697e559a9224d8d3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.34.2/worktrunk-aarch64-unknown-linux-musl.tar.xz"
      sha256 "97eab13d84208c7b7d5f20ab7d88a4962e8eb03c38316eb7028936f6497225c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-sixty/worktrunk/releases/download/v0.34.2/worktrunk-x86_64-unknown-linux-musl.tar.xz"
      sha256 "20d9c8be83bd795bfad8c4bf01a140c0c9142bfa8ae81fc96bedf464c1e4c175"
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
