class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "http://expect.sourceforge.net"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45/expect5.45.tar.gz"
  sha256 "b28dca90428a3b30e650525cdc16255d76bb6ccd65d448be53e620d95d5cc040"

  bottle do
    rebuild 1
    sha256 "59b6373f2b3a09cd5fd2d28513e23c2ba3bb2c6d39a9a47e81c2a0d41aa77b58" => :x86_64_linux
  end

  option "with-threads", "Build with multithreading support"
  if OS.mac?
    option "with-brewed-tk", "Use Homebrew's Tk (has optional Cocoa and threads support)"
  else
    option "without-brewed-tk", "Don't use Homebrew's Tk"
  end

  deprecated_option "enable-threads" => "with-threads"

  depends_on "homebrew/dupes/tcl-tk" if build.with? "brewed-tk"

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fix Tcl private header detection.
  # https://sourceforge.net/p/expect/patches/17/
  patch do
    url "https://sourceforge.net/p/expect/patches/17/attachment/expect_detect_tcl_private_header_os_x_mountain_lion.patch"
    sha256 "bfce1856da9aaf5bcb89673da3be4f96611658cb05d5fbbba3f5287e359ff686"
  end

  def install
    args = ["--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-shared"
    args << "--enable-threads" if build.with? "threads"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

    if build.with? "brewed-tk"
      args << "--with-tcl=#{Formula["tcl-tk"].opt_prefix}/lib"
    else
      ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers/tcl-private"
      args << "--with-tcl=#{MacOS.sdk_path}/usr/lib"
    end
    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
  end

  test do
    system "#{bin}/mkpasswd"
  end
end
