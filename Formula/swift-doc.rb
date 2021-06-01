# frozen_string_literal: true

# :nodoc:
class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", tag: "1.0.0-rc.1", revision: "7dfb210585a72a34080575adb1edf041889a6eb4"

  license "MIT"
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
