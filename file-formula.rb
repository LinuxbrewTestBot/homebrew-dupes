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
    sha256 "23e98e27a13e15e5f24c7c52fe7d6e0c49ec2cd53e572f4f2823a99af69eb593" => :el_capitan
    sha256 "2cdfbee9acc5a545cbe395eeee1388fcdf8dfe3f9c970dd530b891dfb5bcc2c0" => :yosemite
    sha256 "292d9623781b174dec6c53fda62a9e056311b81d17960d7693796532b24fcc05" => :mavericks
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
