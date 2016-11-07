class Libiconv < Formula
  desc "Conversion library"
  homepage "https://www.gnu.org/software/libiconv/"
  url "https://ftpmirror.gnu.org/libiconv/libiconv-1.14.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz"
  sha256 "72b24ded17d687193c3366d0ebe7cde1e6b18f0df8c55438ac95be39e8a30613"

  bottle do
    sha256 "64d8a9383ba42ba3e41422bb8548ebc8f296f67fdda6e6d6a324f990b03c6db0" => :el_capitan
    sha256 "a0d9ff36269bc908fde4a039d2083152202055a2e053b6582ad2c9063c85ebc2" => :yosemite
    sha256 "456a816a94427c963fa3cb90257830aa33268f22443cf5a8a4cf1be3e3ed3bb9" => :mavericks
    sha256 "7b49cfe45f49d4807fbc3cfcc1c456208f1d412ff2044ff095e21a74d2054435" => :x86_64_linux
  end

  keg_only :provided_by_osx

  option :universal

  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/9be2793af/libiconv/patch-Makefile.devel"
    sha256 "ad9b6da1a82fc4de27d6f7086a3382993a0b16153bc8e8a23d7b5f9334ca0a42"
  end

  if OS.mac?
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/9be2793af/libiconv/patch-utf8mac.diff"
      sha256 "e8128732f22f63b5c656659786d2cf76f1450008f36bcf541285268c66cabeab"
    end
  end

  if OS.linux?
    patch do
      url "https://gist.githubusercontent.com/valkjsaaa/b715fd8c2596780ebd00eced2b2d63af/raw/dfdd0c2d3407505628d00319f1ade67f3e42679d/patch-oldglibc.patch"
      sha256 "b58fcfdd96e93d6b34a53d97adb0b789031082fdde8bc56022b0537024e1f7c6"
    end
  end

  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    ENV.j1

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-extra-encodings"
    system "make", "-f", "Makefile.devel", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    system "make", "install"
  end
end


__END__
diff --git a/lib/flags.h b/lib/flags.h
index d7cda21..4cabcac 100644
--- a/lib/flags.h
+++ b/lib/flags.h
@@ -14,6 +14,7 @@
 
 #define ei_ascii_oflags (0)
 #define ei_utf8_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
+#define ei_utf8mac_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
 #define ei_ucs2_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
 #define ei_ucs2be_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
 #define ei_ucs2le_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
