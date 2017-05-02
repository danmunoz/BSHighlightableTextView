//
//  BSHighlightableTextView.swift
//  PPSOIED
//
//  Created by Daniel Munoz on 4/27/17.
//  Copyright © 2017 Brosoft. All rights reserved.
//

import UIKit

class BSHighlightableTextView: UITextView {
    private var highlightedRanges = [NSRange]()
    private var highlightTextTitle = ""
    private var highlightTextColor = UIColor.yellow
    @IBInspectable var highlightTitle: String? {
        get {
            return highlightTextTitle
        }
        set(highlightTitle) {
            highlightTextTitle = highlightTitle!
        }
    }
    @IBInspectable var highlightColor: UIColor? {
        get {
            return highlightTextColor
        }
        set(highlightColor) {
            highlightTextColor = highlightColor!
        }
    }
    
    private func hightlightText() {
        let attributed = NSMutableAttributedString(attributedString: self.attributedText)
        attributed.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clear, range: NSRange(location: 0, length: attributed.length - 1))
        for range in highlightedRanges {
            attributed.addAttribute(NSBackgroundColorAttributeName, value: highlightTextColor, range: range)
        }
        self.attributedText = attributed
    }
    
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
    
    func selectHighlightArea() {
        let indexes = intersect()
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
    
    private func intersect() -> [Int] {
        var indexArray = [Int]()
        for (index, range) in highlightedRanges.enumerated() {
            let intersection = NSIntersectionRange(self.selectedRange, range)
            if intersection.length > 0 {
                indexArray.append(index)
            }
        }
        return indexArray
    }
    
    override func draw(_ rect: CGRect) {
        addCustomMenu()
        hightlightText()
    }
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
