class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", :tag => "0.1.0", :revision => "3ff6fa68a704b715a9a2409f32fa9d87a9935cae"
  head "https://github.com/SwiftDocOrg/swift-doc.git", :shallow => false

  depends_on :xcode => ["11.4", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doc"
  end
end
