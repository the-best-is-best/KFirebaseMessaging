Pod::Spec.new do |s|
  s.name             = 'KFirebaseMessaging'
  s.version          = '0.1.0'
  s.summary          = 'A short description of KFirebaseMessaging.'

  # This description is used to generate tags and improve search results.
  s.description      = <<-DESC
KFirebaseMessaging is a library for managing Firebase Cloud Messaging functionalities, enabling easy integration and handling of remote notifications in iOS applications.
                       DESC

  s.homepage         = 'https://github.com/72160249/KFirebaseMessaging'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '72160249' => 'michelle.raouf@52ndsolution.net' }
  s.source           = { :git => 'https://github.com/72160249/KFirebaseMessaging.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'  # Ensure your deployment target is set appropriately.

  s.source_files = 'KFirebaseMessaging/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KFirebaseMessaging' => ['KFirebaseMessaging/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  # Define dependencies correctly
  s.dependency 'Firebase/Messaging', '11.3.0' # Updated to specify Firebase Messaging directly
  s.dependency 'Firebase/Core', '11.3.0'      # Include Firebase Core if you need basic functionalities
end
