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
        self.isOpaque = false
        self.backgroundColor = backgroundColor;
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        
        
        backgroundColor?.setFill()
        UIRectFill(rect);
        
        // clear the background in the given rectangles
        for holeRectValue in rectsArray {
            let holeRectV:NSValue = holeRectValue as! NSValue
            let holeRect:CGRect = holeRectV.cgRectValue
            let holeRectIntersection:CGRect = holeRect.intersection( rect )
            UIColor.clear.setFill()
            UIRectFill(holeRectIntersection);
        }
        
        for aRect in circles {
            
            let holeRectIntersection:NSValue = aRect as! NSValue
            
            let context = UIGraphicsGetCurrentContext();
            
            if( holeRectIntersection.cgRectValue.intersects( rect ) )
            {
                context?.addEllipse(in: holeRectIntersection.cgRectValue)
                context?.clip()
                guard context != nil else {
                    return
                }
                context!.clear(holeRectIntersection.cgRectValue)
                context!.setFillColor( UIColor.clear.cgColor)
                context!.fill( holeRectIntersection.cgRectValue)
            }
        }
        
    }
    
}
