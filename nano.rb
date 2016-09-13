# nano: Build a bottle for Linuxbrew
class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.7/nano-2.7.0.tar.gz"
  mirror "https://ftp.gnu.org/pub/gnu/nano/nano-2.7.0.tar.gz"
  sha256 "5dd1e9cf8e3de676c141a0b23f312e68380ef049926e2913e2114bbe32fbeac3"

  bottle do
    sha256 "9a25cf9750ffdd409f3cc02acae52d7a71d494b2705fa2772f23ba56f01e9a0d" => :el_capitan
    sha256 "227834d524af6a0478fbb55edae188af52dd2276e632c33d1fe4890ca1eff93e" => :yosemite
    sha256 "8ce412434c4a9b011aba4526493768f9be4cb7d5e714dd50b0e22fd0eed3b88c" => :mavericks
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
