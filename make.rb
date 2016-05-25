# make: Build a bottle for Linuxbrew
class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "http://ftpmirror.gnu.org/make/make-4.2.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/make/make-4.2.tar.bz2"
  sha256 "4e5ce3b62fe5d75ff8db92b7f6df91e476d10c3aceebf1639796dc5bfece655f"

  bottle do
    sha256 "e6f872ec47d2157a7d5ae3f6854128844f8e305fb7ee54dd98c23fa7c4bc1561" => :el_capitan
    sha256 "c5cc8218cc2f379bdb8f5c5fb3847ac4a952f952cd6169b232f68d2cd99527f5" => :yosemite
    sha256 "04dd0b10205bce4ed7e0c58fea3363a72fe7116346fa0ae7fe7fa4116832f60a" => :mavericks
    sha256 "e38903e23b2d3f87208d185a150dc3c5f6ab95965fafc2ee56a40d70ae5b386c" => :x86_64_linux
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "guile" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--with-guile" if build.with? "guile"
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      default:
      \t@echo Homebrew
    EOS

    cmd = build.with?("default-names") ? "make" : "gmake"

    assert_equal "Homebrew\n",
      shell_output("#{bin}/#{cmd}")
  end
end
