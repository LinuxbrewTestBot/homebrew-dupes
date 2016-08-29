# less: Build a bottle for Linuxbrew
class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "https://ftpmirror.gnu.org/less/less-481.tar.gz"
  mirror "http://www.greenwoodsoftware.com/less/less-481.tar.gz"
  sha256 "3fa38f2cf5e9e040bb44fffaa6c76a84506e379e47f5a04686ab78102090dda5"

  bottle do
    sha256 "cf4c3df646286aea336150390468c182816ca704e8077dc97802b9d283431575" => :x86_64_linux
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
