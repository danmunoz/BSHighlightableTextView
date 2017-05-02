//
//  BSHighlightableTextView.swift
//  PPSOIED
//
//  Created by Daniel Munoz on 4/27/17.
//  Copyright © 2017 Brosoft. All rights reserved.
//

import UIKit

///A subclass of UITextView that can be easily highlighted.

class BSHighlightableTextView: UITextView {
    
    ///The ranges highlited on the text.
    
    private var highlightedRanges = [NSRange]()
    
    ///The text that will appear on the copy/paste menu.
    
    private var highlightTextTitle = ""
    
    ///The color of the highlighted area.
    
    private var highlightTextColor = UIColor.yellow
    
    ///The text that will appear on the copy/paste menu. Editable on Interface Builder
    
    @IBInspectable var highlightTitle: String? {
        get {
            return highlightTextTitle
        }
        set(highlightTitle) {
            highlightTextTitle = highlightTitle!
        }
    }
    
    ///The color of the highlighted area. Editable on Interface Builder
    
    @IBInspectable var highlightColor: UIColor? {
        get {
            return highlightTextColor
        }
        set(highlightColor) {
            highlightTextColor = highlightColor!
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    init(aFrame: CGRect, aTextContainer: NSTextContainer?, highlightText: String?, highlightColor: UIColor?) {
        super.init(frame: aFrame, textContainer: aTextContainer)
        if let highlightText = highlightText {
            self.highlightTextTitle = highlightText
        }
        if let highlightColor = highlightColor {
            self.highlightTextColor = highlightColor
        }
        customInit()
    }
    
    func customInit() {
        addCustomMenu()
        hightlightText()
    }
    
    /**
     
     Highlights the selected text based on the ranges stored on the 'highlightedRanges' array.
     
     */
    
    private func hightlightText() {
        let attributed = NSMutableAttributedString(attributedString: self.attributedText)
        attributed.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clear, range: NSRange(location: 0, length: attributed.length - 1))
        for range in highlightedRanges {
            attributed.addAttribute(NSBackgroundColorAttributeName, value: highlightTextColor, range: range)
        }
        self.attributedText = attributed
        let algo = BSHighlightableTextView(aFrame: CGRect(x: 0, y: 0, width: 100, height: 100), aTextContainer: nil, highlightText: "Highlight", highlightColor: UIColor.red)
    }
    
    /**
     
     Adds the "Highlight" option to the menu. The text will vary depending on what was set on IB. Once a title is set it will persist through all other BSHighlightableTextView on the app.
     
     */
    
    private func addCustomMenu() {
        let text = highlightTextTitle.characters.count > 0 ? highlightTextTitle : "Highlight"
        let hightlight = UIMenuItem(title: text, action: #selector(self.selectHighlightArea))
        if UIMenuController.shared.menuItems == nil || UIMenuController.shared.menuItems?.count == 0 {
            UIMenuController.shared.menuItems = [hightlight]
        }
        else {
            for item in UIMenuController.shared.menuItems! {
                if item.action == #selector(selectHighlightArea) {
                    return
                }
            }
            UIMenuController.shared.menuItems?.append(hightlight)
        }
    }
    
    /**
     
     The method called when the user taps on the "highlight" option on the menu.
     
     */
    
    func selectHighlightArea() {
        let indexes = intersect(with: self.selectedRange)
        if indexes.count == 1 {
            if let newRange = highlightedRanges[indexes.first!].join(range2: self.selectedRange) {
                highlightedRanges.remove(at: indexes.first!)
                self.highlightedRanges.append(newRange)
            }
            else {
                if let newRanges = highlightedRanges[indexes.first!].difference(range2: self.selectedRange) {
                    highlightedRanges.remove(at: indexes.first!)
                    for range in newRanges {
                        if range.length > 1 {
                            self.highlightedRanges.append(range)
                        }
                    }
                }
            }
        }
        else if indexes.count > 1 {
            var newHighlightedRanges = [NSRange]()
            var matchedRanges = [NSRange]()
            for (index, range) in highlightedRanges.enumerated() {
                if indexes.contains(index) {
                    matchedRanges.append(range)
                }
                else {
                    newHighlightedRanges.append(range)
                }
            }
            matchedRanges.append(self.selectedRange)
            let newRange = NSRange.multipleJoin(ranges: matchedRanges)
            highlightedRanges.removeAll()
            highlightedRanges = newHighlightedRanges
            highlightedRanges.append(newRange)
        }
        else {
            self.highlightedRanges.append(self.selectedRange)
        }
        self.hightlightText()
    }
    
    /**
     
     Method that checks if the selected range intersects with one from the 'highlightedRanges' array.
     
     - Parameters:
     - selectedRange: Selected NSRange of the UITextView
     
     - Returns: The indexes of the interesctions.
     
     */
    
    private func intersect(with selectedRange: NSRange) -> [Int] {
        var indexArray = [Int]()
        for (index, range) in highlightedRanges.enumerated() {
            let intersection = NSIntersectionRange(selectedRange, range)
            if intersection.length > 0 {
                indexArray.append(index)
            }
        }
        return indexArray
    }
    
//    override func draw(_ rect: CGRect) {
//        addCustomMenu()
//        hightlightText()
//    }
}

extension NSRange{
    
    func endLocation() -> Int {
        return self.location + self.length
    }
    
    func join(range2: NSRange) -> NSRange? {
        if range2.endLocation() == self.endLocation() {
            if range2.location < self.location {
                return NSRange(location: range2.location, length: (self.endLocation() - range2.location))
            }
            return nil
        }
        else if range2.location == self.location{
            if self.length > range2.length {
                return nil
            }
            else {
                return NSRange(location: self.location, length: range2.length)
            }
        }
        else if range2.location > self.location {
            if range2.endLocation() < self.endLocation() {
                return nil
            }
            return NSRange(location: self.location, length: (range2.endLocation() - self.location))
        }
        else if range2.location < self.location {
            if range2.length > self.length {
                return NSRange(location: range2.location, length: range2.length)
            }
            return NSRange(location: range2.location, length: (self.endLocation() - range2.location))
        }
            
        else {
            return nil
        }
    }
    
    static func multipleJoin(ranges: [NSRange]) -> NSRange {
        var minLocation = ranges.first?.location
        var maxLocation = ranges.first?.endLocation()
        for range in ranges {
            if range.location < minLocation!  {
                minLocation = range.location
            }
            if range.endLocation() > maxLocation!  {
                maxLocation = range.endLocation()
            }
        }
        return NSRange(location: minLocation!, length: maxLocation! - minLocation!)
    }
    
    func difference(range2: NSRange) -> [NSRange]? {
        let intersection = NSIntersectionRange(self, range2)
        if intersection.location == self.location {
            return [NSRange(location: self.location + range2.length, length: self.length - range2.length)]
        }
        else if intersection.endLocation() == self.endLocation() {
            return [NSRange(location: self.location, length: self.length - range2.length)]
        }
        else {
            return [NSRange(location: self.location, length: range2.location - self.location), NSRange(location: range2.endLocation(), length: self.endLocation() - range2.endLocation())]
        }
    }
}
