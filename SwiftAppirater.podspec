Pod::Spec.new do |s|
  s.name             = 'SwiftAppirater'
  s.version          = '0.1.0'
  s.summary          = 'A Swift version of Appirater.'

  s.description      = <<-DESC
Original version of Appirater is in https://github.com/arashpayan/appirater.
                       DESC

  s.homepage         = 'https://github.com/zhouhao27/SwiftAppirater'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zhou Hao' => 'zhou.hao.27@gmail.com' }
  s.source           = { :git => 'https://github.com/zhouhao27/SwiftAppirater.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftAppirater/Classes/**/*'
  
end
