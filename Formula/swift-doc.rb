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

  def install
    system "swift", "build",
           "-c", "release",
           "--disable-sandbox",
           "--build-path", buildpath.to_s

    libexec.install buildpath/"release/swift-doc" => "swift-doc"
    libexec.install Dir[buildpath/"release/*.bundle"]

    (bin/"swift-doc").tap do |path|
      path.write <<~SHELL
        #!/bin/sh
        exec "#{prefix}/libexec/swift-doc" "$@"
      SHELL
      chmod 0555, path
    end
  end

  test do
    system "#{bin}/swift-doc"
  end
end
