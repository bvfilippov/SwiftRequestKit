
Pod::Spec.new do |s|
  s.name             = 'SwiftRequestKit'
  s.version          = '0.1.7'
  s.summary          = 'SwiftRequestKit is an SDK for making network requests in Swift.'
  s.description      = <<-DESC
                       SwiftRequestKit is an extensive SDK designed for making network requests in Swift. It provides a simplified interface for API calls, response handling, and error management.
                       DESC
  s.homepage         = 'https://philippovs.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bogdan Filippov' => 'bvfilippov@gmail.com' }
  s.source           = { :git => 'https://github.com/bvfilippov/SwiftRequestKit.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '12.0'
  s.source_files     = 'SwiftRequestKit/**/*.{h,m,swift}'
  s.frameworks       = 'Foundation'
  s.swift_versions   = ['5.0']
end
