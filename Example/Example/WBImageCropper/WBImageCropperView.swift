//
//  WBImageCropperView.swift
//  Example
//
//  Created by APPLE on 21/11/2015.
//  Copyright © 2015 Muhammad Waqas Bhati. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


class WBImageCropperView:UIView {
    var rectsArray:NSArray = []
    var circles:NSArray = []
    var backColor:UIColor = UIColor.init()
    
    required init(frame:CGRect,backgroundColor:UIColor,rects:NSArray){
        
        rectsArray = rects;
        super.init(frame: frame)
        // Initialization code
        self.opaque = false
        self.backgroundColor = backgroundColor;
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        
        
        backgroundColor?.setFill()
        UIRectFill(rect);
        
        // clear the background in the given rectangles
        for holeRectValue in rectsArray {
            let holeRectV:NSValue = holeRectValue as! NSValue
            let holeRect:CGRect = holeRectV.CGRectValue()
            let holeRectIntersection:CGRect = CGRectIntersection( holeRect, rect )
            UIColor.clearColor().setFill()
            UIRectFill(holeRectIntersection);
        }
        
        for aRect in circles {
            
            let holeRectIntersection:NSValue = aRect as! NSValue
            
            let context = UIGraphicsGetCurrentContext();
            
            if( CGRectIntersectsRect( holeRectIntersection.CGRectValue(), rect ) )
            {
                CGContextAddEllipseInRect(context, holeRectIntersection.CGRectValue());
                CGContextClip(context);
                CGContextClearRect(context, holeRectIntersection.CGRectValue());
                CGContextSetFillColorWithColor( context, UIColor.clearColor().CGColor)
                CGContextFillRect( context, holeRectIntersection.CGRectValue());
            }
        }
        
    }
    
}