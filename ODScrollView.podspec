#
# Be sure to run `pod lib lint ODScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ODScrollView'
  s.version          = '0.1.3'
  s.summary          = 'ODScrollView is a framework that moves editable text areas like UITextField and UITextView vertically depending on keyboard visibility.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'One of the most common situations while developing an iOS application is that is getting input from the user with UIViews that conform UITextInput protocol such as UITextField and UITextView on many screens, primarily login, registration and form screens. In these cases, we often encounter the overlap of the this UIViews with the keyboard. ODScrollView is a UIScrollView that automatically detects this UIViews and moves them according to the given settings. Besides that it has lots of other features and is developer friendly!'

  s.homepage         = 'https://github.com/orcundeniz/ODScrollView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Orçun Deniz' => 'deniz.orcun@outlook.com' }
  s.source           = { :git => 'https://github.com/orcundeniz/ODScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '[5.0, 5.1, 5.2]'

  s.source_files = 'ODScrollView/Classes/**/*'
  s.frameworks = 'UIKit'
  # s.resource_bundles = {
  #   'ODScrollView' => ['ODScrollView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
