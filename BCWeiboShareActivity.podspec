#
# Be sure to run `pod lib lint BCWeiboShareActivity.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BCWeiboShareActivity'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BCWeiboShareActivity.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    TODO: Add long description of the pod here.
                       DESC

    s.homepage         = 'https://github.com/<GITHUB_USERNAME>/BCWeiboShareActivity'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'caiwenbo' => 'caiwenbo@rd.netease.com' }
    s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/BCWeiboShareActivity.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '7.0'

    s.source_files = 'BCWeiboShareActivity/Classes/**/*.{h,m}'
    s.resources    = ['SinaActivity/Assets/**/*']

    s.resource_bundles = {
      'BCWeiboShareActivity' => ['BCWeiboShareActivity/Assets/*']
    }

    s.vendored_libraries  = 'BCWeiboShareActivity/Classes/libWeiboSDK/libWeiboSDK.a'
    s.frameworks   = 'ImageIO', 'SystemConfiguration', 'CoreText', 'QuartzCore', 'Security', 'UIKit', 'Foundation', 'CoreGraphics','CoreTelephony'
    s.libraries = 'sqlite3', 'z'
    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }

end
