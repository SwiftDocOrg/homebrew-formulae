class SwiftDoctest < Formula
  desc "Swift documentation tester"
  homepage "https://github.com/SwiftDocOrg/DocTest"
  url "https://github.com/SwiftDocOrg/DocTest.git", :tag => "0.0.2", :revision => "c02403705966011f81d3472eb2c1faa223cbd426"
  head "https://github.com/SwiftDocOrg/swift-doc.git", :shallow => false

  depends_on :xcode => ["11.4", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doctest", "--help"
  end
end
