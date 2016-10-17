# openldap: Build a bottle for Linuxbrew
class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "http://www.openldap.org/software/"
  url "ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.43.tgz"
  mirror "http://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.43.tgz"
  sha256 "34d78e5598a2b0360d26a9050fcdbbe198c65493b013bb607839d5598b6978c8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8b55762758ce839c54a427462bd311cf9604be6258b5c07dfc65e779a70ed1b2" => :sierra
    sha256 "bcbe0d00fc34d029211b5de10a68bbdb0be078c3197039356e4d0f25d01e82f2" => :el_capitan
    sha256 "95bb3356c3b5c61be00583cd0351a538dc0f017db25c6cf054badd0756e56e9c" => :yosemite
    sha256 "04eaf232b92dbe18a1d717c7070481ef6a0f3883c6fa3fa04a7963c83c1ff2ec" => :x86_64_linux
  end

  keg_only :provided_by_osx

  option "with-sssvlv", "Enable server side sorting and virtual list view"

  depends_on "berkeley-db4" => :optional
  depends_on "groff" => :build unless OS.mac?
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
    ]

    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "berkeley-db4"
    args << "--enable-sssvlv=yes" if build.with? "sssvlv"

    system "./configure", *args
    system "make", "install"
    (var+"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
