# krb5: Build a bottle for Linuxbrew
class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "http://web.mit.edu/kerberos/"
  url "http://web.mit.edu/kerberos/dist/krb5/1.14/krb5-1.14.tar.gz"
  sha256 "cedb07fad8331e3ff2983d26e977a2ddba622f379c2b19bfea85bd695930f9e9"

  bottle do
    sha256 "d6c9632dcc50fbe987e43a6b4dca02422aadf448d7fbd53ebf75f419c3c118f4" => :el_capitan
    sha256 "a5616ee867f2cebf1108109e418b1668355c150b60942b6551e785c27680f3ed" => :yosemite
    sha256 "7e8182d2f02d34a517fb2601c9d9307539e8d6910f24cacd3ad17a5de711e53e" => :mavericks
    sha256 "29376eeb03e0dd3b08b7a7690dcea5b024974d756a8de3163a4900baa422f9db" => :x86_64_linux
  end

  keg_only :provided_by_osx

  depends_on "openssl"

  def install
    cd "src" do
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
