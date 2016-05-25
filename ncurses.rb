class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://www.gnu.org/s/ncurses/"
  url "http://ftpmirror.gnu.org/ncurses/ncurses-6.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz"
  sha256 "f551c24b30ce8bfb6e96d9f59b42fbea30fa3a6123384172f9e7284bcf647260"
  revision 1

  bottle do
    sha256 "3d608e7522a8855cb760ba8d8b3e7fa2e9896389844f6b89f67f652e710a08c6" => :el_capitan
    sha256 "c22a8d91d717757fe2e1c8a84c41151bd81e1651368681fe20a0283d8e5e745f" => :yosemite
    sha256 "87ebfc0fd5a86ac7a3a5d574f0cb513b5e8d856768b31609451d9e655ece8f19" => :mavericks
    sha256 "65a4fb6eae29b3ca3dd9461aa93b76c505c96b203dc38c3d739725143922492e" => :x86_64_linux
  end

  keg_only :provided_by_osx

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?

    # Fix the build for GCC 5.1
    # error: expected ')' before 'int' in definition of macro 'mouse_trafo'
    # See https://lists.gnu.org/archive/html/bug-ncurses/2014-07/msg00022.html
    # and http://trac.sagemath.org/ticket/18301
    # Disable linemarker output of cpp
    ENV.append "CPPFLAGS", "-P"

    (lib/"pkgconfig").mkpath

    system "./configure", "--prefix=#{prefix}",
                          "--enable-pc-files",
                          "--with-pkg-config-libdir=#{lib}/pkgconfig",
                          "--enable-sigwinch",
                          "--enable-symlinks",
                          "--enable-widec",
                          "--mandir=#{man}",
                          "--with-manpage-format=normal",
                          "--with-shared",
                          "--with-gpm=no"
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.to_s.split(".")[0]

    cd lib do
      %w[form menu ncurses panel].each do |name|
        if OS.mac?
          ln_s "lib#{name}w.#{major}.dylib", "lib#{name}.dylib"
          ln_s "lib#{name}w.#{major}.dylib", "lib#{name}.#{major}.dylib"
        else
          ln_s "lib#{name}w.so.#{major}", "lib#{name}.so"
          ln_s "lib#{name}w.so.#{major}", "lib#{name}.so.#{major}"
        end
        ln_s "lib#{name}w.a", "lib#{name}.a"
        ln_s "lib#{name}w_g.a", "lib#{name}_g.a"
      end

      ln_s "libncurses++w.a", "libncurses++.a"
      ln_s "libncurses.a", "libcurses.a"
      if OS.mac?
        ln_s "libncurses.dylib", "libcurses.dylib"
      else
        ln_s "libncurses.so", "libcurses.so"
        ln_s "libncurses.so", "libtinfo.so"
      end
    end

    cd lib/"pkgconfig" do
      ln_s "ncursesw.pc", "ncurses.pc"
    end

    cd bin do
      ln_s "ncursesw#{major}-config", "ncurses#{major}-config"
    end

    ln_s [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/term.h", "ncursesw/termcap.h"], include
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"tput", "cols"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/keynames"
    system testpath/"test/bin/test_arrays"
    system testpath/"test/bin/test_vidputs"
  end
end
