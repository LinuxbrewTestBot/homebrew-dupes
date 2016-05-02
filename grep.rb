# grep: Build a bottle for Linuxbrew
class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "http://ftpmirror.gnu.org/grep/grep-2.25.tar.xz"
  mirror "https://ftp.gnu.org/gnu/grep/grep-2.25.tar.xz"
  sha256 "e21e83bac50450e0d0d61a42c154ee0dceaacdbf4f604ef6e79071cb8e596830"

  bottle do
    cellar :any
    sha256 "7579ec27cef1d811bf2874d2bd6bf09cb4c539a9a0ebd514c9fd80cef66b7e4c" => :el_capitan
    sha256 "d35e9e3207befba741af5ac5c26d03779b36343e88ad9ab6207b0528a32d479f" => :yosemite
    sha256 "ff6189185cf4a271ab024e18aff37294f985b8c4b03791b654ef9d30891064ed" => :mavericks
  end

  option "with-default-names", "Do not prepend 'g' to the binary"
  deprecated_option "default-names" => "with-default-names"

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names"
      option.
      EOS
    end
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"
    cmd = build.with?("default-names") ? "grep" : "ggrep"
    grepped = shell_output("#{bin}/#{cmd} match #{text_file}")
    assert_match "should be matched", grepped
  end
end
