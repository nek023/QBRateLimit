#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QBRateLimit"
  s.version          = "1.0.0"
  s.summary          = "Rate limit controller."
  s.description      = "A rate limit controller for avoiding excess HTTP requests or preventing UI from tapped repeatedly."
  s.homepage         = "https://github.com/questbeat/QBRateLimit"
  s.license          = 'MIT'
  s.author           = { "questbeat" => "questbeat@gmail.com" }
  s.source           = { :git => "https://github.com/questbeat/QBRateLimit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/questbeat'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes'
end
