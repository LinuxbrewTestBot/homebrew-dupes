class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  # 4.89 has major problems on OS X blocking upgrade for now.
  # https://github.com/Homebrew/homebrew-dupes/pull/537
  # url "ftp://sunsite.ualberta.ca/pub/Mirror/lsof/lsof_4.88.tar.bz2"
  url "https://mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/OLD/lsof_4.88.tar.bz2"
  sha256 "fe6f9b0e26b779ccd0ea5a0b6327c2b5c38d207a6db16f61ac01bd6c44e5c99b"

  bottle do
    cellar :any_skip_relocation
    sha256 "166741406a0a1d6ac78b82274d56f1bb1d24c4d4cd2421919e48ce42566f90ca" => :el_capitan
    sha256 "b8292349936eea9e0f24daf01818cba06ce5e689b4e97f026a431034c509e67d" => :yosemite
    sha256 "92a1f687aa8a0df343b90771e16f6a11aa60968c034c9660318e38142533fb82" => :mavericks
    sha256 "c8b71e4182d76d9d4715bdef0dbdbe1678c37b4f2597ff7d2f1472a4bfd2d2fa" => :x86_64_linux
  end

  def install
    ENV["LSOF_INCLUDE"] = "#{MacOS.sdk_path}/usr/include"

    system "tar", "xf", "lsof_#{version}_src.tar"

    cd "lsof_#{version}_src" do
      # Source hardcodes full header paths at /usr/include
      inreplace %w[dialects/darwin/kmem/dlsof.h dialects/darwin/kmem/machine.h
                   dialects/darwin/libproc/machine.h],
                "/usr/include", MacOS.sdk_path.to_s + "/usr/include"

      mv "00README", "../README"
      system "./Configure", "-n", OS::NAME
      system "make"
      bin.install "lsof"
    end
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
