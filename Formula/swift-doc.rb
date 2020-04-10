class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", :tag => "1.0.0-beta.2", :revision => "dbb361185b701922f395b385085303a3d8da19e7"
  head "https://github.com/SwiftDocOrg/swift-doc.git", :shallow => false

  depends_on :xcode => ["11.4", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doc"
  end
end
