# openldap: Build a bottle for Linuxbrew
class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "http://www.openldap.org/software/"
  url "ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.43.tgz"
  mirror "http://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.43.tgz"
  sha256 "34d78e5598a2b0360d26a9050fcdbbe198c65493b013bb607839d5598b6978c8"

  bottle do
    cellar :any
    sha256 "853d71820cbb7f604004c4f6d4f0196610d5df5a7b71be9480d5439567943853" => :el_capitan
    sha256 "0b59c5418184ff1a96514369ddf34d8388c8f1306d2231d831b7984a74b4f48f" => :yosemite
    sha256 "210e5b3b003c0b47a5c2f0274255fff80424576de46cda43525919db6e6fd7a6" => :mavericks
  end

  keg_only :provided_by_osx

  option "with-memberof", "Include memberof overlay"
  option "with-unique", "Include unique overlay"
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
    ]

    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "berkeley-db4"
    args << "--enable-memberof" if build.with? "memberof"
    args << "--enable-unique" if build.with? "unique"
    args << "--enable-sssvlv=yes" if build.with? "sssvlv"

    system "./configure", *args
    system "make", "install"
    (var+"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end
end
