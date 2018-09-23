//
//  BSHighlightableTextView.swift
//  PPSOIED
//
//  Created by Daniel Munoz on 4/27/17.
//  Copyright © 2017 Brosoft. All rights reserved.
//

import UIKit

///A UITextView subclass that can be easily highlighted.

class BSHighlightableTextView: UITextView {
    
    ///The view's viewIdentifier that will be used to persist highlighted ranges.
    
    private var viewIdentifier = ""
    
    ///The ranges highlited on the text.
    
    private var highlightedRanges = [NSRange]()
    
    ///The text that will appear on the copy/paste menu.
    
    private var highlightTextTitle = ""
    
    ///The color of the highlighted area.
    
    private var highlightTextColor = UIColor.yellow
    
    ///The identifier of the BSHighlightableTextView, this will be used for persistence.
    
    @IBInspectable var textViewidentifier: String? {
        get {
            return viewIdentifier
        }
        set(textViewidentifier) {
            viewIdentifier = textViewidentifier!
        }
    }
    
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
        self.customInit()
        self.viewIdentifier = aDecoder.decodeObject(forKey: "viewIdentifier") as? String ?? ""
        self.highlightedRanges = aDecoder.decodeObject(forKey: "highlightedRanges") as? [NSRange] ?? [NSRange]()
        self.highlightTextTitle = aDecoder.decodeObject(forKey: "highlightTextTitle") as? String ?? ""
        self.highlightTextColor = aDecoder.decodeObject(forKey: "highlightTextColor") as? UIColor ?? UIColor.yellow
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.viewIdentifier, forKey: "viewIdentifier")
        aCoder.encode(self.highlightedRanges, forKey: "highlightedRanges")
        aCoder.encode(self.highlightTextTitle, forKey: "highlightTextTitle")
        aCoder.encode(self.highlightTextColor, forKey: "highlightTextColor")
    }
    
    /**
     
     Persists the BSHighlightableTextView object to Userdefaults
     
     */
    
    private func persist() {
        if self.viewIdentifier.count > 0 {
            let data  = NSKeyedArchiver.archivedData(withRootObject: self)
            UserDefaults.standard.set(data, forKey:"BSHighlight-" + self.viewIdentifier)
        }
    }
    
    /**
     
     Retrieves a BSHighlightableTextView object from UserDefaults
     
     - Returns: An initialized BSHighlightableTextView object (can be nil).
     
     */
    
    private func getPersistedData() -> BSHighlightableTextView? {
        if self.viewIdentifier.count > 0 {
            guard let data = UserDefaults.standard.object(forKey: "BSHighlight-" + self.viewIdentifier) as? Data else { return nil }
            let textView = NSKeyedUnarchiver.unarchiveObject(with: data) as? BSHighlightableTextView
            return textView
        }
        else {
            return nil
        }
    }
    
    func customInit() {
        self.addCustomMenu()
        self.hightlightText()
    }
    
    override func draw(_ rect: CGRect) {
        if let textView = getPersistedData() {
            self.viewIdentifier = textView.viewIdentifier.replacingOccurrences(of: "BSHighlight-", with: "")
            self.highlightedRanges = textView.highlightedRanges
            self.highlightTextTitle = textView.highlightTextTitle
            self.highlightTextColor = textView.highlightTextColor
            self.hightlightText()
        }
    }
    
    /**
     
     Creates a new text view with the specified text container, highlight text and highlight color.
     
     - Parameters:
     - aFrame: The frame rectangle of the text view.
     - aTextContainer: The text container to use for the receiver (can be nil).
     - viewIdentifier: The BSHighlightableTextView object identifier, this name must be unique since this is used for persisting the highlighted state of the text view.
     - highlightText: The text that will appear on the menu item (can be nil).
     - highlightColor: The color that will be displayed when highlighted (can be nil).
     
     - Returns: An initialized BSHighlightableTextView.
     
     */
    
    init(aFrame: CGRect, aTextContainer: NSTextContainer?, viewIdentifier: String!, highlightText: String?, highlightColor: UIColor?) {
        super.init(frame: aFrame, textContainer: aTextContainer)
        self.viewIdentifier = viewIdentifier
        if let highlightText = highlightText {
            self.highlightTextTitle = highlightText
        }
        if let highlightColor = highlightColor {
            self.highlightTextColor = highlightColor
        }
        self.customInit()
    }
    
    /**
     
     Highlights the selected text based on the ranges stored on the 'highlightedRanges' array.
     
     */
    
    private func hightlightText() {
        let attributed = NSMutableAttributedString(attributedString: self.attributedText)
        if attributed.length > 0 {
            attributed.addAttribute(.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: attributed.length - 1))
            for range in highlightedRanges {
                attributed.addAttribute(.backgroundColor, value: highlightTextColor, range: range)
            }
            self.attributedText = attributed
            self.persist()
        }
    }
    
    /**
     
     Adds the "Highlight" option to the menu. The text will vary depending on what was set on IB. Once a title is set it will persist through all other BSHighlightableTextView on the app.
     
     */
    
    private func addCustomMenu() {
        let text = highlightTextTitle.count > 0 ? highlightTextTitle : "Highlight"
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
    
    @objc func selectHighlightArea() {
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
     
     - Parameter selectedRange: Selected NSRange of the UITextView
     
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
