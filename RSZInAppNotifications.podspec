Pod::Spec.new do |s|
  s.name          = 'RSZInAppNotifications'
  s.version       = '1.0.1'
  s.summary       = 'In-app notifications mechanism for your app'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.platform      = :ios , '7.0'
  s.homepage      = 'https://github.com/rad3ks/RSZInAppNotifications'
  s.requires_arc  = 'true'
  s.author        = {
    'Radosław Szeja' => 'rad3ks@gmail.com'
  }
  s.source        = {
    :git => 'https://github.com/rad3ks/RSZInAppNotifications.git',
    :tag => s.version
  }
  s.source_files  = 'RSZInAppNotifications/*.{h,m}'

end
