# libedit: Build a bottle for Linuxbrew
class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "http://thrysoee.dk/editline/"
  url "http://thrysoee.dk/editline/libedit-20150325-3.1.tar.gz"
  version "20150325-3.1"
  sha256 "c88a5e4af83c5f40dda8455886ac98923a9c33125699742603a88a0253fcc8c5"

  bottle do
    cellar :any
    sha256 "f2412c8ce6d8651b32f52389942b8e7c777e0cb6cc9237d2c55a6b7dd0392143" => :yosemite
    sha256 "03a8764730a83c6438e25aeee88c1b68c4b69fa9d257f7154f80ccc15c403a5c" => :mavericks
    sha256 "302a08f178639005bbd9ca6732775ef36f98371772d95a66373f30d3856e812a" => :mountain_lion
    sha256 "13bdbcf0f595d4ebf9d22a54cf4da54965e0ec7c02072be572f06e66c773f9bc" => :x86_64_linux
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-widec",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
