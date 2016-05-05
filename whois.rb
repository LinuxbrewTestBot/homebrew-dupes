class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.kernel.org/debian/pool/main/w/whois/whois_5.2.12.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.2.12.tar.xz"
  sha256 "b26d4027b8987d9911466aa06ce2c167a50017cd59a622a429bd506222f6cdf1"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63841c25019475d98c643bec3b011b4ec35f2894b4a551a73a7563b82798d5bd" => :el_capitan
    sha256 "a4009cd13ec8f76fce92ae20a54dd745efb3563f7cebdb157816cd675d28f038" => :yosemite
    sha256 "23dd4d87315ba52c86a436a113214a6b2e10c300a7398957af12b5a8c9116e66" => :mavericks
  end

  def install
    # autodie was not shipped with the system perl 5.8
    inreplace "make_version_h.pl", "use autodie;", "" if MacOS.version < :snow_leopard

    args = []
    args << "HAVE_ICONV=1" << "whois_LDADD+=-liconv" if OS.mac?
    system "make", "whois", *args
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<-EOS.undent
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
