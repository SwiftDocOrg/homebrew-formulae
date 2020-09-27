class SwiftDoc < Formula
  desc "Swift documentation generator"
  homepage "https://github.com/SwiftDocOrg/swift-doc"
  url "https://github.com/SwiftDocOrg/swift-doc.git", tag: "1.0.0-beta.4", revision: "581af2fe50667ed2f49c53d26b91a8feb4531302"
  head "https://github.com/SwiftDocOrg/swift-doc.git", shallow: false

  depends_on xcode: ["11.4", :build]
  depends_on "graphviz" => :recommended

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swift-doc"
  end
end
