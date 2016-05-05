# file-formula: Build a bottle for Linuxbrew
# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.25.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.25.tar.gz"
  sha256 "3735381563f69fb4239470b8c51b876a80425348b8285a7cded8b61d6b890eca"

  head "https://github.com/file/file.git"

  bottle do
    cellar :any
    revision 1
    sha256 "17cb380bfdf672e4cad9a324f1e81f7cc72d2f390cc8a732046f976b21362641" => :el_capitan
    sha256 "3116d7d15a6ca96347b53af0c28773f5d7a35b41de8f7451f9c23ef1196b7dda" => :yosemite
    sha256 "cace05a8a01b3a64b7e4c0d848b5abf69395750f63169fdd7eb460b4944f3556" => :mavericks
    sha256 "a12b00e01998d645f729feaef012e2c66f3dadeaff9c23516cd331f89f8240fd" => :x86_64_linux
  end

  keg_only :provided_by_osx

  depends_on "libmagic"

  def install
    # Clean up "src/magic.h" as per http://bugs.gw.com/view.php?id=330
    rm "src/magic.h"

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
