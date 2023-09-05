
Pod::Spec.new do |s|
  s.name             = 'SwiftRequestKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SwiftRequestKit.'
  s.description      = <<-DESC
                       A longer description of SwiftRequestKit SDK.
                       DESC
  s.homepage         = 'https://philippovs.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'b@philippovs.com' }
  s.source           = { :git => 'https://github.com/bvfilippov/SwiftRequestKit.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '12.0'
  s.source_files     = 'ServiceManager/SwiftRequestKit/**/*.{h,m,swift}'
  s.frameworks       = 'Foundation', 'UIKit'
end
