Pod::Spec.new do |s|
  s.name             = 'KFirebaseMessaging'
  s.version          = '0.1.0-rc.1'
  s.summary          = 'KFirebaseMessaging: A Kotlin Multiplatform library that simplifies the integration of Firebase Cloud Messaging (FCM) into your apps, enabling push notifications across Android and iOS platforms with minimal setup.
'

  # This description is used to generate tags and improve search results.
  s.description      = "KFirebaseMessaging is a robust Kotlin Multiplatform library designed to facilitate the seamless integration of Firebase Cloud Messaging (FCM) in your applications. By leveraging Kotlin's shared code capabilities, this library allows developers to implement push notifications effortlessly across both Android and iOS platforms, including Objective-C interoperability.`"

  s.homepage         = 'https://github.com/the-best-is-best/KFirebaseMessaging'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'the-best-is-best' => 'michelle.raouf@52ndsolution.net' }
  s.source           = { :git => 'https://github.com/the-best-is-best/KFirebaseMessaging.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'  # Ensure your deployment target is set appropriately.
  s.swift_version    = '5.5'

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
