# nano: Build a bottle for Linuxbrew
class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "http://www.nano-editor.org/"
  url "http://www.nano-editor.org/dist/v2.5/nano-2.5.3.tar.gz"
  mirror "ftp://ftp.gnu.org/pub/gnu/nano/nano-2.5.3.tar.gz"
  sha256 "b2b060129b9feff2d4870d803a441178c96531de9aed144ec0b83bd63ccb12ee"
  revision 1

  bottle do
    sha256 "dd1f04766fed84d5bdefd2aa8806a9c1b487052def4cbbfe8243367dc49d1538" => :el_capitan
    sha256 "e42450e199a37640660c1ae0d0674d78146c9d29c356108d050712c09e6e3679" => :yosemite
    sha256 "7aed49ce01bab697738add47dfaedaa4d9e7bdf3f22097b2bdb9745977ed1c84" => :mavericks
    sha256 "9c2202b1f2042e42de5eaae06f2fdf5d49b0c59945cfecbc44330ec29ec59b18" => :x86_64_linux
  end

  head do
    url "http://git.savannah.gnu.org/r/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "homebrew/dupes/ncurses"

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
