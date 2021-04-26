# frozen_string_literal: true

# :nodoc:
class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", tag: "1.0.0-beta.6", revision: "81f2d3a1731204693f41929b76b33e2abb5e4b4c"

  license "MIT"
  head "https://github.com/SwiftDocOrg/swift-doc.git", shallow: false

  bottle do
    root_url "https://github.com/SwiftDocOrg/swift-doc/releases/download/1.0.0-beta.6"

    sha256 cellar: :any, big_sur:  "8136c33316600b12b7c388a2055cb20875b3817d185a820100e0228916419987"
    sha256 cellar: :any, catalina: "bdd665bf19fbe86a96dbbd7dd7f1f8ec0878991e81b3ee05bb12e66fca53f903"
  end

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
