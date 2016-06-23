# less: Build a bottle for Linuxbrew
class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "http://ftpmirror.gnu.org/less/less-481.tar.gz"
  mirror "http://www.greenwoodsoftware.com/less/less-481.tar.gz"
  sha256 "3fa38f2cf5e9e040bb44fffaa6c76a84506e379e47f5a04686ab78102090dda5"

  bottle do
    revision 1
    sha256 "78f87c61e209d93787232cf52e72d206d8e9393b2616e982645f02c46ad436dc" => :el_capitan
    sha256 "7f16df4d7504ce78543faafd814c5581d95ed56e2041bb63fa466cb452bcaebf" => :yosemite
    sha256 "94ce48c78105e4ed73d524806d4fe45b2fb1f4c84f25b0d129fa62d9128c93fe" => :mavericks
  end

  depends_on "pcre" => :optional
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-regex=pcre" if build.with? "pcre"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
