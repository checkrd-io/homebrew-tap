class CheckrdCli < Formula
  desc "Checkrd command-line interface — control plane operations from your terminal."
  homepage "https://checkrd.io"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.3/checkrd-cli-aarch64-apple-darwin.tar.gz"
      sha256 "11cb401a7d57030040750bd78d5eb054803af37c8c383e4e449187ca4bfe4fbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.3/checkrd-cli-x86_64-apple-darwin.tar.gz"
      sha256 "eaf5da29e581cd15a01aa0ad0975638aa101e2dff5bf1c0bf0c4517d573618ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.3/checkrd-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd10dbb33f1224b12342f8ef69d3e1b1b0102749e5e5f6c2e40325327810df05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.3/checkrd-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4a58c8ce84014834af5aa53c75b4345a8296df0fbca9d14c9f3d71a9aebb9444"
    end
  end
  license "Apache-2.0"
  link_overwrite "bin/checkrd"

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
