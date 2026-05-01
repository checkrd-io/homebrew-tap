class CheckrdCli < Formula
  desc "Checkrd command-line interface — control plane operations from your terminal."
  homepage "https://checkrd.io"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-aarch64-apple-darwin.tar.gz"
      sha256 "86208352b767f6e9aebfc049c54183241a09af0023e6f6f94c5b4184f392f7fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-x86_64-apple-darwin.tar.gz"
      sha256 "bcb8e4b805f2b239b7c4c939ba23d76f22cd5afedb80492058ff094ce65a97b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ec9e7eab9ee700232bac39c694afeb6ac0a9e4cb35b6abb6d9e73cc5892ba17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "481ce2a46c231d8271ae61f353de7f781e76108f33580569941250d7e3c853f7"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "checkrd" if OS.mac? && Hardware::CPU.arm?
    bin.install "checkrd" if OS.mac? && Hardware::CPU.intel?
    bin.install "checkrd" if OS.linux? && Hardware::CPU.arm?
    bin.install "checkrd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
