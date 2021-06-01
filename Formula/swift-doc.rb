# frozen_string_literal: true

# :nodoc:
class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", tag: "1.0.0-rc.1", revision: "f935ebfe524a0ff27bda07dadc3662e3e45b5125"

  license "MIT"

  bottle do
    root_url "https://github.com/SwiftDocOrg/swift-doc/releases/download/1.0.0-rc.1"
    rebuild 1
    sha256 cellar: :any, big_sur: "facc5a29dd94781561b7a6ed3e8c2173e1a47132114adbb0e280bd77323e74f6"
    sha256 cellar: :any, catalina: "5c8db14f65e320906973e682ead065e4ed888c626d632a274227086d7bc41fbb"
  end

  head "https://github.com/SwiftDocOrg/swift-doc.git", shallow: false

  depends_on xcode: ["12", :build]
  depends_on "graphviz"

  def install
    system "swift", "build",
           "-c", "release",
           "--disable-sandbox",
           "--build-path", buildpath.to_s

    copy_toolchain_libraries!

    libexec.install buildpath/"release/swift-doc" => "swift-doc"
    libexec.install Dir[buildpath/"release/*.bundle"]

    install_shim!
  end

  test do
    system bin/"swift-doc"
  end

  private

  def copy_toolchain_libraries!
    return unless Hardware::CPU.intel? && Hardware::CPU.is_64_bit?

    macho = MachO.open(buildpath/"release/swift-doc")
    return unless (toolchain = macho.rpaths.find { |path| path.include?(".xctoolchain") })

    cp "#{toolchain}/lib_InternalSwiftSyntaxParser.dylib", buildpath, verbose: true
    lib.install buildpath/"lib_InternalSwiftSyntaxParser.dylib"

    macho.delete_rpath toolchain
    macho.change_install_name "@rpath/lib_InternalSwiftSyntaxParser.dylib",
                              "#{lib}/lib_InternalSwiftSyntaxParser.dylib"

    macho.write!
  end

  def install_shim!
    (bin/"swift-doc").tap do |path|
      path.write <<~SHELL
        #!/bin/sh
        exec "#{prefix}/libexec/swift-doc" "$@"
      SHELL
      chmod 0555, path
    end
  end
end
