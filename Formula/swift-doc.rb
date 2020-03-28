class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", :tag => "0.0.4", :revision => "f852a149365e2ece4417b4e1ffc4d1094b644cb7"
  head "https://github.com/SwiftDocOrg/swift-doc.git", :shallow => false

  depends_on :xcode => ["11.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doc"
  end
end
