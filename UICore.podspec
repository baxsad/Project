#
#  Be sure to run `pod spec lint UICore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "UICore"
  s.version      = "0.0.1"
  s.summary      = "A iOS UIComponents Kit for Develop of UICore."
  s.description  = "UICore Kit for iOS Development efficiency! 2333333333333"
  s.homepage     = "https://github.com/iURWang/Project"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "pmo" => "wangrui@bangbangbang.cn" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/iURWang/Project.git", :tag => "0.0.1" }
  s.source_files  = "Project", "Project/Common/UICore/**/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  # s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
