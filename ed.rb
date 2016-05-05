class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "http://ftpmirror.gnu.org/ed/ed-1.12.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.12.tar.lz"
  sha256 "d2655743144a0f6071a619dea2e142d75d2335b3dbfe8d4a643984a10e0a802f"

  bottle do
    cellar :any_skip_relocation
    sha256 "54c52be45bd1e33bcc50aab372e9ba3c2ef1cc7de5412b568710aa4ad1a55129" => :el_capitan
    sha256 "3992f9c431767907a9156ff007dd9431406dd384394d2da8fd48eb43b6baeb57" => :yosemite
    sha256 "10f5f317d4a6943c53b58fa937e9a14214a164b3cd764e2b747473b230b8a2a1" => :mavericks
    sha256 "e8b9212f903c45265a4a84d2ef600668109b8a5ae357e8b70882ae9ee35f27c2" => :x86_64_linux
  end

  deprecated_option "default-names" => "with-default-names"
  option "with-default-names", "Don't prepend 'g' to the binaries"

  def install
    ENV.j1

    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, reinstall using the "with-default-names" option.
      EOS
    end
  end

  test do
    testfile = (testpath/"test")
    testfile.write "Hello world"
    ed = bin/(build.with?("default-names") ? "ed" : "ged")
    pipe_output("#{ed} -s #{testfile}", ",s/o//\nw\n")
    assert_equal "Hell world", testfile.read.chomp
  end
end
