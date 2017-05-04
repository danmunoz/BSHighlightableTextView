Pod::Spec.new do |s|
  s.name         = "BSHighlightableTextView"
  s.version      = "1.0.1"
  s.summary      = "An easy way to add highlight functionality to UITextView."
  s.description  = <<-DESC
  If you ever wanted to add the highlight feature to a UITextView this if the easiest solution.
                   DESC
  s.homepage     = "http://brosoftapps.com"
  s.license      = "MIT"
  s.ios.deployment_target  = '9.0'
  s.author             = { "Dan Munoz" => "itdann@me.com" }
  s.social_media_url   = "http://twitter.com/makias"
  s.source       = { :git => "https://github.com/danmunoz/BSHighlightableTextView.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "BSHighlight/Classes/*.swift"
end
