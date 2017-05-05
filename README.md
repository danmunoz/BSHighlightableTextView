# BSHighlightableTextView

![CocoaPods](https://img.shields.io/badge/pod-v1.0.1-blue.svg)

`BSHighlightableTextView` is an easy way to add highlight functionality to UITextView.

<div align="center">
    <img src="https://raw.githubusercontent.com/danmunoz/danmunoz.github.io/master/Assets/BSHighlightableTextView/screenshot1.png" height="534" width="300"">
    <img src="https://raw.githubusercontent.com/danmunoz/danmunoz.github.io/master/Assets/BSHighlightableTextView/screenshot2.png" height="534" width="300"">
</div>

## Features

- [x] Regular `UITextView` functionality
- [x] Custom title for "Highlight" menu
- [x] Custom color for highlight
- [x] Easy implementation
- [x] Works with attributted text without changing format
- [x] Swift
- [x] CocoaPods support
- [x] Persistence

# Requirements

 - Swift 3
 - iOS 9 or higher


# Installation

## CocoaPods
To install BSHighlightableTextView using CocoaPods, please integrate it in your existing Podfile, or create a new Podfile:

```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
  pod 'BSHighlightableTextView'
end
```

Then run `pod install`.

# Usage
`BSHighlightableTextView` is written in Swift. You can use Interface Builder to set the properties of the view or you can do it programmatically:

```swift
//'highlightText' can be nil, the default value will be "Highlight".
//'highlightColor' can be nil, the default value will be Yellow.
let textView = BSHighlightableTextView(aFrame: CGRect(x: 0, y: 0, width: 100, height: 100), aTextContainer: nil, identifier: "myTextView1", highlightText: "Highlight", highlightColor: UIColor.red)
self.view.addSubview(textView)

```

# Support
If you have any question of feature request feel free to reach out on [Twitter](http://www.twitter.com/Makias) [@Makias](http://www.twitter.com/Makias) or on [Stack Overflow](http://stackoverflow.com) with the tag BSHighlightableTextView. If you find any bug please post an issue or submit a pull request.

# License

BSHighlightableTextView is distributed under the MIT license.

