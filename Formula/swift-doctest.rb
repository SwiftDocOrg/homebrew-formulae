class SwiftDoctest < Formula
  desc "Swift documentation tester"
  homepage "https://github.com/SwiftDocOrg/DocTest"
  url "https://github.com/SwiftDocOrg/DocTest.git", :tag => "0.0.1", :revision => "a0a41e608ed8ffeec71ca4a16a5cee7aa06fd3b3"
  head "https://github.com/SwiftDocOrg/swift-doc.git", :shallow => false

  depends_on :xcode => ["11.4", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doctest", "--help"
  end
end
