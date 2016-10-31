# nano: Build a bottle for Linuxbrew
class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.7/nano-2.7.1.tar.gz"
  mirror "https://ftp.gnu.org/pub/gnu/nano/nano-2.7.1.tar.gz"
  sha256 "81547310d3ab7a220426c9c2f2435a372fb43d4b27818f016de25698862ae118"

  bottle do
    sha256 "76ee35d372bb904b0480d571cd0b1287136e9f188fc703b9deec45dc90d802b7" => :sierra
    sha256 "7e3c393ba34e9c325a6d0549ac63a97657b002d4e75fd0fc2142ecb3c57837e2" => :el_capitan
    sha256 "4ba695e1e953c68c4e599aaf6a2b1a824874ae81ada620ca95a28a551b01ba8b" => :yosemite
    sha256 "85730d93e43d19e51efcda4201cdf0d2ea52eacbd79a07b858170ff9c4b52b36" => :x86_64_linux
  end

  head do
    url "http://git.savannah.gnu.org/r/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "homebrew/dupes/ncurses"
  depends_on "libmagic" unless OS.mac?

  def install
    # Otherwise SIGWINCH will not be defined
    ENV.append_to_cflags "-U_XOPEN_SOURCE" if MacOS.version < :leopard

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
