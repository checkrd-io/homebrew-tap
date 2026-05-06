class CheckrdCli < Formula
  desc "Checkrd command-line interface — control plane operations from your terminal."
  homepage "https://checkrd.io"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.4/checkrd-cli-aarch64-apple-darwin.tar.gz"
      sha256 "915f78f5ac3de6c102f2931e137fd22e9d96793d0375870d9bd47a37d80b2669"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.4/checkrd-cli-x86_64-apple-darwin.tar.gz"
      sha256 "8d743f5bedd2650703e7f44b562549616d32c796eeca2f2d75cd7cb260f9063c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.4/checkrd-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "241b06a75a3333447922ede677b4545151e9126498129eb117b943e456d0b59a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/checkrd-io/checkrd-cli/releases/download/checkrd-cli-v0.1.4/checkrd-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d8b78d85e83de133d41eaec350aa4835124426c12405c933dfdeb8990430ba1"
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
