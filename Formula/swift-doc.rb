class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", :tag => "1.0.0-beta.3", :revision => "a2013b64ffbcf91be45e6ecff9e88fdf8019a08d"
  head "https://github.com/SwiftDocOrg/swift-doc.git", :shallow => false

  depends_on :xcode => ["11.4", :build]
  depends_on "graphviz" => :recommended

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doc"
  end
end
