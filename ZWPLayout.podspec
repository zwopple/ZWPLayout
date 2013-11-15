Pod::Spec.new do |s|
  s.name = "ZWPLayout"
  s.summary = "Autolayout as simple as c = m*x+b"
  
  s.version = "1.0.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.homepage = "https://github.com/zwopple/ZWPLayout"
  s.author = { "Zwopple | Creative Software" => "support@zwopple.com" }
  s.platform = :ios, "6.0"
  s.source = { :git => "https://github.com/zwopple/ZWPLayout.git", :tag => "1.0.0" }
  s.requires_arc = true
  s.source_files = "ZWPLayout/"
  s.frameworks = "UIKit"
  
end