# frozen_string_literal: true

# :nodoc:
class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", tag: "1.0.0-beta.4", revision: "581af2fe50667ed2f49c53d26b91a8feb4531302"

  license "MIT"

  head "https://github.com/SwiftDocOrg/swift-doc.git", shallow: false

  bottle do
    root_url "https://github.com/SwiftDocOrg/swift-doc/releases/download/1.0.0-beta.4"
    sha256 "e5ca21737ea0aad9d0fd71f573f2f889a70d96eae33f3cb6f731fa8e8e6348e5" => :catalina
  end

  depends_on xcode: ["11.4", :build]
  depends_on "graphviz" => :recommended

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doc"
  end
end
