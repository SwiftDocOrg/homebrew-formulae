# frozen_string_literal: true

# :nodoc:
class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", tag: "1.0.0-beta.5", revision: "f441648bcb8a6b07a3724bc1af2488e8a6e6c184"

  license "MIT"

  head "https://github.com/SwiftDocOrg/swift-doc.git", shallow: false

  depends_on xcode: ["12", :build]
  depends_on "graphviz" => :recommended

  bottle do
    root_url "https://github.com/SwiftDocOrg/swift-doc/releases/download/1.0.0-beta.5"
    cellar :any
    sha256 "77c1bfb0902dcf1d5ee532c627425c5ef131ead68d9b66223988b2a2f5eff25d" => :catalina
  end

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

  # rubocop:disable Metrics/AbcSize
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
  # rubocop:enable Metrics/AbcSize

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
