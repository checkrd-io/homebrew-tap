class CheckrdCli < Formula
  desc "Checkrd command-line interface — control plane operations from your terminal."
  homepage "https://checkrd.io"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-aarch64-apple-darwin.tar.gz"
      sha256 "5783899394c48475c2e937c7bb8aceab4ade99988eeee9d63dd4686fc315e1e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-x86_64-apple-darwin.tar.gz"
      sha256 "6becbd2daf825626cd4cf955e34e72ee00043928cc171249816d16321dadc337"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8c9881b571e84c230b3f4cee209e23d07827fa7f4bbf0b4b774286272eec1f27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.0/checkrd-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "88bda8bc54c0e52d7a5046f3ec73e12c73fedc42fa457ddf3a1fbb92c0ebc30e"
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
