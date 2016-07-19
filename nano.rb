# nano: Build a bottle for Linuxbrew
class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v2.6/nano-2.6.1.tar.gz"
  mirror "https://ftp.gnu.org/pub/gnu/nano/nano-2.6.1.tar.gz"
  sha256 "56f2ba1c532647bee36abd5f87a714400af0be084cf857a65bc8f41a0dc28fe5"

  bottle do
    sha256 "c12444852823c315eb78d60b9f76d46b7c67dd40d93790acbe17639a5ae8bd51" => :x86_64_linux
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
