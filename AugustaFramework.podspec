Pod::Spec.new do |s|
          #1.
          s.name               = "AugustaFramework"
          #2.
          s.version            = "1.0.0"
          #3.  
          s.summary         = "iOS Framework for Augusta"
          #4.
          s.homepage        = "https://www.augustahitech.com"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "Augusta"
          #7.
          s.platform            = :ios, "10.0"
          #8.
          s.source              = { :git => "https://github.com/augustasoftware/iOS_Framework.git", :tag => "1.0.0" }
          #9.
          s.source_files     = "AugustaFramework", "AugustaFramework/**/*.{h,m,swift}"
 	  #10.
#s.dependency 'PayCardsRecognizer'
	  s.dependency 'Alamofire'
	  s.dependency 'SwiftyJSON'
	  s.dependency 'AMTumblrHud'
#s.dependency 'FacebookCore'
#s.dependency 'FacebookLogin'
#s.dependency 'FacebookShare'
#s.dependency 'TwitterKit'
#s.dependency 'PinterestSDK'
#s.dependency 'Stripe'
	  s.dependency 'IQKeyboardManagerSwift'
#s.dependency 'VGPlayer'
	   
	  #11
	  s.resources = "AugustaFramework/**/*.xib"
 	  s.ios.resource_bundle = { 'AugustaFramework' => 'AugustaFramework/Resources/**/*' }
	  
    end
