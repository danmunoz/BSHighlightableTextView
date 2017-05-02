# BSHighlightableTextView

![CocoaPods](https://img.shields.io/badge/pod-v0.0.1-blue.svg)

`BSHighlightableTextView` is an easy way to add highlight functionality to UITextView.

<div align="center">
    
</div>

## Features

- [x] Regular `UITextView` functionality
- [x] Custom title for "Highlight" menu
- [x] Custom color for highlight
- [x] Easy implementation
- [x] Works with attributted text without changing format
- [x] Swift
- [x] CocoaPods support
- [ ] Persistence

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
`BSHighlightableTextView` is written in Swift.

## Basic

```swift
let textView = BSHighlightableTextView(aFrame: CGRect(x: 0, y: 0, width: 100, height: 100), aTextContainer: nil, highlightText: "Highlight", highlightColor: UIColor.red)
self.view.addSubview(textView)

```

# Support
If you have any question of feature request feel free to reach out on [Twitter](http://www.twitter.com/Makias) [@Makias](http://www.twitter.com/Makias) or on [Stack Overflow](http://stackoverflow.com) with the tag BSHighlightableTextView. If you find any bug please post an issue or submit a pull request.

# License

BSHighlightableTextView is distributed under the MIT license.

