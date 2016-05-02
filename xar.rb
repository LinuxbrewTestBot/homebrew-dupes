# xar: Build a bottle for Linuxbrew
class Xar < Formula
  desc "eXtensible ARchiver"
  homepage "https://code.google.com/p/xar/"
  url "https://xar.googlecode.com/files/xar-1.5.2.tar.gz"
  sha256 "4c5d5682803cdfab16d72365cf51fc4075d597c5eeaa8c7d1990fea98cdae3e6"

  bottle do
    cellar :any
    sha256 "bbfa085a98db775ad409b2c269d243cbb72b174217548032e8574815409787d2" => :yosemite
    sha256 "c8365275e6eca371ae338b192ec5d281ebb95ba93c4a7d92ee34044951ac3c23" => :mavericks
    sha256 "1a78012dc77213f699d3dc4f061b9fe5add0c6a53699dcec69b31ce1cb72e7fa" => :mountain_lion
  end

  keg_only :provided_by_osx

  depends_on "openssl"

  # Known issue upstream:
  # https://code.google.com/p/xar/issues/detail?id=51
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    touch "testfile.txt"
    system bin/"xar", "-cv", "testfile.txt", "-f", "test.xar"
    assert File.exist?("test.xar")
    assert_match "testfile.txt", shell_output("#{bin}/xar -tv -f test.xar")
  end
end

__END__
diff -Naur old/lib/archive.c new/lib/archive.c
--- old/lib/archive.c
+++ new/lib/archive.c
@@ -79,6 +79,10 @@
 #define LONG_MIN INT32_MIN
 #endif

+#if LIBXML_VERSION < 20618
+#define xmlDictCleanup()        /* function doesn't exist in older API */
+#endif
+
 static int32_t xar_unserialize(xar_t x);
 void xar_serialize(xar_t x, const char *file);
