# file-formula: Build a bottle for Linuxbrew
# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.28.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.28.tar.gz"
  sha256 "0ecb5e146b8655d1fa84159a847ee619fc102575205a0ff9c6cc60fc5ee2e012"

  head "https://github.com/file/file.git"

  bottle do
    cellar :any
    sha256 "bc7bbeaaf1599f1e1bf9eb4671f34427b9c98880080adbdc6db954e36a51600c" => :x86_64_linux
  end

  keg_only :provided_by_osx

  depends_on "libmagic"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install-exec"
    system "make", "-C", "doc", "install-man1"
    rm_r lib
  end

  test do
    system "#{bin}/file", test_fixtures("test.mp3")
  end
end
