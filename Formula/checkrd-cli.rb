class CheckrdCli < Formula
  desc "Checkrd command-line interface — control plane operations from your terminal."
  homepage "https://checkrd.io"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.1/checkrd-cli-aarch64-apple-darwin.tar.gz"
      sha256 "ff897d1f19e9b264febf4ace9d0ea6e3ac4873fe0b72ab237bb152223483639d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.1/checkrd-cli-x86_64-apple-darwin.tar.gz"
      sha256 "c43c01a4b81201f2b3e8e44f71480fafd068100e2607cac11c5a758865287041"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.1/checkrd-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d76e493a7dff60d042dc4a1532aa255e4131224e0a1357d51b1d25c00239a01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.1/checkrd-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0ce5330cc539aafd8c40a8729f841cccce4ab691dd80cea64c0598202848943f"
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
