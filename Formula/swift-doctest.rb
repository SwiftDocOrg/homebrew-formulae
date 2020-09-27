# frozen_string_literal: true

class SwiftDoctest < Formula
  desc "Swift documentation tester"
  homepage "https://github.com/SwiftDocOrg/DocTest"
  url "https://github.com/SwiftDocOrg/DocTest.git", tag: "0.1.0", revision: "37995d5a6be780957f566535c63668bd3407c842"
  head "https://github.com/SwiftDocOrg/swift-doc.git", shallow: false

  depends_on xcode: ["11.4", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doctest", "--help"
  end
end
