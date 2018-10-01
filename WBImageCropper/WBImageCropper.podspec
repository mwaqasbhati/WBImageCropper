#
# Be sure to run `pod lib lint WBImageCropper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WBImageCropper'
  s.version          = '0.1.0'
  s.summary          = 'This controller will provide you cropping of an image with different inout masks'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This amazing library will provide you a user friendly view to do the cropping of an input image. We have to provide an input image and required cropping mask. we need to confirm to its delegate in which you will get the cropped image with the desired mask'

  s.homepage         = 'https://github.com/mwaqasbhati/WBImageCropper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'WBImageCropper/LICENSE' }
  s.author           = { 'mwaqasbhati' => 'm.waqas.bhati@hotmail.com' }
  s.source           = { :git => 'https://github.com/mwaqasbhati/WBImageCropper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.2'
  s.ios.deployment_target = '10.0'
  s.source_files = 'WBImageCropper/WBImageCropper/Classes/*.swift'
  
  # s.resource_bundles = {
  #   'WBImageCropper' => ['WBImageCropper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
