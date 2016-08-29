# diffutils: Build a bottle for Linuxbrew
class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftpmirror.gnu.org/diffutils/diffutils-3.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/diffutils/diffutils-3.5.tar.xz"
  sha256 "dad398ccd5b9faca6b0ab219a036453f62a602a56203ac659b43e889bec35533"

  bottle do
    cellar :any_skip_relocation
    sha256 "4583e00a56f9a7c6af0b35a351b0a71de7f44e09370469fabaa0e3747294ff0f" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
