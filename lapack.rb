# lapack: Build a bottle for Linuxbrew
class Lapack < Formula
  desc "Linear Algebra PACKage"
  homepage "http://www.netlib.org/lapack/"
  url "http://www.netlib.org/lapack/lapack-3.6.0.tgz"
  sha256 "a9a0082c918fe14e377bbd570057616768dca76cbdc713457d8199aaa233ffc3"

  bottle do
    revision 1
    sha256 "1dbfb0c4eb4c5654e1f5f2712e7a69a764aa6560a1334f363ab8fd0946d4c281" => :el_capitan
    sha256 "03154ac5c8cd043d8d13918488c5ddd960217673659cb4d9d14e0ca78ae2b04f" => :yosemite
    sha256 "678c0f4325b788cd52ff06e51bc4186e8f0a2cd5625a3dfab15ddde648521659" => :mavericks
    sha256 "b313b2d49d204fd2f1664abb94c507c82112bb03c1f8f313747247303d60d733" => :x86_64_linux
  end

  keg_only :provided_by_osx

  option "with-doxygen", "Build man pages with Doxygen"
  depends_on "doxygen" => :optional

  depends_on :fortran
  depends_on "cmake" => :build

  def install
    if build.with? "doxygen"
      mv "make.inc.example", "make.inc"
      system "make", "man"
      man3.install Dir["DOCS/man/man3/*"]
    end
    system "cmake", ".", "-DBUILD_SHARED_LIBS:BOOL=ON", "-DLAPACKE:BOOL=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "lapacke.h"
      int main() {
        void *p = LAPACKE_malloc(sizeof(char)*100);
        if (p) {
          LAPACKE_free(p);
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-I#{include}", "-llapacke", "-o", "test"
    system "./test"
  end
end
