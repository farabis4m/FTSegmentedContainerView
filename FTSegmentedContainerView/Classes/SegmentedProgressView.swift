//
//  SegmentedProgressView.swift
//  Stories
//
//  Created by Aswin Babu on 3/21/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import Foundation
import UIKit

public class SegmentedProgressView: UIView, ProgressBarElementViewDelegate {
    
    public weak var delegate: ProgressBarDelegate?
    
    override public var frame: CGRect {
        didSet {
            redraw()
        }
    }
    
    public var progressTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var trackTintColor: UIColor? {
        didSet {
            redraw()
        }
    }
    
    public var itemSpace: Double? {
        didSet {
            redraw()
        }
    }
    
    public var items: [ProgressItem]? {
        didSet {
            redraw()
        }
    }
    
    var elementViews: [SegmentView] = []
    var toLoadElementViews: [SegmentView] = []
    
    public init(withItems items: [ProgressItem]!) {
        self.items = items
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    fileprivate func redraw() {
        clear()
        draw()
    }
    
    fileprivate func clear() {
        elementViews.removeAll()
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    private var currentAnimationIndex = 0
    
    // Set the required Segments in the view
    public func configureSegmentView(with items: [SegmentView]) {
        toLoadElementViews = items
        elementViews = items
        redraw()
        
    }
    
    fileprivate func draw() {
            
        elementViews = toLoadElementViews
        
        let horizontalSpace: Double = itemSpace ?? 6.0
        var elementWidth = ((Double(bounds.width) + horizontalSpace) / Double(elementViews.count))
        elementWidth -= horizontalSpace
        
        if elementWidth <= 0 { return }
      
        var xOffset: Double = 0.0

        // Customizing the segments as the container needs
        for  elementView in elementViews {
            elementView.progressTintColor = self.progressTintColor
            elementView.trackTintColor = self.trackTintColor
            elementView.delegate = self
            elementView.frame = CGRect(x: xOffset, y: 0, width: elementWidth, height: Double(bounds.height))
            elementView.drawEmpty()
            self.addSubview(elementView)
            xOffset += elementWidth + horizontalSpace
        }

    }
    
    public func progressBar(didFinishWithElement element: SegmentView, isBack: Bool) {
        delegate?.progressBarFinished(finishedItem: isBack)
    }

}
