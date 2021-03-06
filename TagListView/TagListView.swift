//
//  TagListView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit


@objc protocol TagListViewDelegate {
    optional func tagPressed(title: String) -> Void
}


@IBDesignable
class TagListView: UIView {
    
    @IBInspectable var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            for tagView in tagViews {
                tagView.textColor = textColor
            }
        }
    }
    @IBInspectable var tagBackgroundColor: UIColor = UIColor.blackColor() {
        didSet {
            for tagView in tagViews {
                tagView.backgroundColor = tagBackgroundColor
            }
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.cornerRadius = cornerRadius
            }
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.borderWidth = borderWidth
            }
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.borderColor = borderColor
            }
        }
    }
    @IBInspectable var paddingY: CGFloat = 2 {
        didSet {
            for tagView in tagViews {
                tagView.paddingY = paddingY
            }
            layoutIfNeeded()
        }
    }
    @IBInspectable var paddingX: CGFloat = 5 {
        didSet {
            for tagView in tagViews {
                tagView.paddingX = paddingX
            }
            layoutIfNeeded()
        }
    }
    @IBInspectable var marginY: CGFloat = 2 {
        didSet {
            layoutIfNeeded()
        }
    }
    @IBInspectable var marginX: CGFloat = 5 {
        didSet {
            layoutIfNeeded()
        }
    }
    var textFont: UIFont = UIFont.systemFontOfSize(12) {
        didSet {
            for tagView in tagViews {
                tagView.textFont = textFont
            }
            layoutIfNeeded()
        }
    }
    
    @IBOutlet var delegate: TagListViewDelegate?

    var tagViews: [TagView] = []
    var tagViewHeight: CGFloat = 0
    var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Interface Builder
    
    override func prepareForInterfaceBuilder() {
        addTag("Welcome")
        addTag("to")
        addTag("TagListView")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for tagView in tagViews {
            tagView.removeFromSuperview()
        }
        
        var currentRow = 0
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        for tagView in tagViews {
            tagView.frame.size = tagView.intrinsicContentSize()
            tagViewHeight = tagView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width + marginX > frame.width {
                currentRow += 1
                tagView.frame.origin.x = 0
                tagView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)
                
                currentRowTagCount = 1
                currentRowWidth = tagView.frame.width + marginX
            }
            else {
                tagView.frame.origin.x = currentRowWidth
                tagView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)
                
                currentRowTagCount += 1
                currentRowWidth += tagView.frame.width + marginX
            }
            
            addSubview(tagView)
        }
        rows = currentRow
    }
    
    // MARK: - Manage tags
    
    override func intrinsicContentSize() -> CGSize {
        let height = CGFloat(rows) * (tagViewHeight + marginY) - marginY
        return CGSizeMake(frame.width, height)
    }
    
    func addTag(title: String) {
        let tagView = TagView(title: title)

        tagView.textColor = textColor
        tagView.backgroundColor = tagBackgroundColor
        tagView.cornerRadius = cornerRadius
        tagView.borderWidth = borderWidth
        tagView.borderColor = borderColor
        tagView.paddingY = paddingY
        tagView.paddingX = paddingX
        tagView.textFont = textFont
        
        tagView.addTarget(self, action: "tagPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        addTagView(tagView)
    }
    
    private func addTagView(tagView: TagView) {
        tagViews.append(tagView)
        setNeedsLayout()
    }
    
    func removeTag(title: String) {
        for (index, tagView) in enumerate(tagViews) {
            if tagView.currentTitle == title {
                tagView.removeFromSuperview()
                tagViews.removeAtIndex(index)
            }
        }
        setNeedsLayout()
    }
    
    func removeAllTags() {
        for tagView in tagViews {
            tagView.removeFromSuperview()
        }
        tagViews = []
        setNeedsLayout()
    }
    
    // MARK: - Events
    
    func tagPressed(sender: UIButton!) {
        if let delegate = delegate, tagPressed = delegate.tagPressed {
            tagPressed(sender.currentTitle ?? "")
        }
    }

}
