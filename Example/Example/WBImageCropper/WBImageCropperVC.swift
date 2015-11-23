//
//  WBImageCropperVC.swift
//  Example
//
//  Created by APPLE on 21/11/2015.
//  Copyright © 2015 Muhammad Waqas Bhati. All rights reserved.
//

import Foundation
import UIKit

protocol pickedImageDelegate{
    
    func didCancel()
    func didDone(croppedImage:UIImage)
}

class WBImageCropperVC:UIViewController,UIGestureRecognizerDelegate {
    
    var delegate:pickedImageDelegate!=nil
    var previousScale:CGFloat = 0.0
    var cornerRadius:CGFloat = 0.0
    var tempFrame:CGRect = CGRectZero
    var tempImage:UIImage = UIImage.init()
    var transView:WBImageCropperView!
    var cropView: UIView!
    var originalImageVw: UIImageView!
    var cancelBtn:UIButton!
    var doneBtn:UIButton!
    
    override func viewDidLoad() {
        self.initializeCropView()
        self.originalImageVw.userInteractionEnabled = true
        self.navigationController?.navigationBarHidden = true
        
    }
    override func viewWillAppear(animated: Bool) {
        self.originalImageVw.image = tempImage
        self.originalImageVw.frame = CGRectMake(0,0,tempImage.size.width,tempImage.size.height)
        var transparentRects:NSArray
        if self.cornerRadius == 0.0 {
            transparentRects = NSArray.init(objects:NSValue.init(CGRect:self.tempFrame))
        }
        else{
            transparentRects = []
        }
        self.transView = WBImageCropperView.init(frame:self.view.frame, backgroundColor:UIColor.init(white:0.0, alpha:0.5), rects:transparentRects)
        self.view.insertSubview(self.transView, aboveSubview:self.cropView)
        self.addGestureToView()
        self.initializeButton()
        
    }
    func initializeCropView(){
        
      self.cropView = UIView.init(frame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height))
   //   self.cropView.backgroundColor = UIColor.blueColor()
      self.originalImageVw = UIImageView.init()
      self.cropView.addSubview(originalImageVw)
      self.view.addSubview(cropView)
    }
    func initializeButton(){
       
        cancelBtn = UIButton.init(type:UIButtonType.Custom)
        cancelBtn.setTitle("Cancel", forState:UIControlState.Normal)
        cancelBtn.addTarget(self, action:Selector("CancelBtnPressed"), forControlEvents:UIControlEvents.TouchUpInside)
        doneBtn = UIButton.init(type:UIButtonType.Custom)
        doneBtn.setTitle("Done", forState:UIControlState.Normal)
        doneBtn.addTarget(self, action:Selector("DoneBtnPressed"), forControlEvents:UIControlEvents.TouchUpInside)
        cancelBtn.sizeToFit()
        doneBtn.sizeToFit()
        self.view.addSubview(cancelBtn)
        self.view.addSubview(doneBtn)
        
    }
    func CancelBtnPressed(){
        
        self.delegate.didCancel()
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
        
    
    }
    func DoneBtnPressed(){
        let image = self.screenshot()
        self.delegate.didDone(image)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    override func viewDidLayoutSubviews() {
        
        cancelBtn.frame = CGRectMake(10.0,20.0,60.0,30.0)
        doneBtn.frame = CGRectMake(self.view.frame.size.width-70.0,20.0,60.0,30.0)
        
        self.cropView.frame = tempFrame
        self.cropView.center = self.view.center
        
        self.cropView.layer.borderWidth = 2.0
        self.cropView.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.cropView.layer.masksToBounds = true
        self.cropView.clipsToBounds = false
        
        if self.cornerRadius == 0.0 {
            self.transView.rectsArray = NSArray.init(objects:NSValue.init(CGRect:self.cropView.frame))
            self.transView.drawRect(self.transView.frame)
            
        }
        else{
            self.transView.circles = NSArray.init(objects:NSValue.init(CGRect:self.cropView.frame))
            self.transView.drawRect(self.transView.frame)
            self.cropView.layer.cornerRadius = self.cropView.frame.size.height/2
            
        }
        
    }
    func addGestureToView(){
        
        let panGesture = UIPanGestureRecognizer(target:self, action:Selector("adjustImage:"))
        panGesture.delegate = self
        self.transView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer.init(target:self, action:Selector("scalePiece:"))
        pinchGesture.delegate = self
        self.transView.addGestureRecognizer(pinchGesture)
        
//        let rotateGesture = UIRotationGestureRecognizer(target: self, action: ("handleRotate:"))
//        self.transView.addGestureRecognizer(rotateGesture)
//        rotateGesture.delegate = self
        
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
//    func handleRotate(recognizer : UIRotationGestureRecognizer) {
//        let state:UIGestureRecognizerState = recognizer.state
//        
//        if (state == UIGestureRecognizerState.Began || state == UIGestureRecognizerState.Changed)
//        {
//            let rotation:CGFloat = recognizer.rotation
//            self.originalImageVw.transform = CGAffineTransformRotate(recognizer.view!.transform, rotation)
//            recognizer.rotation = 0.0
//        }
//    }
    func scalePiece(recognizer:UIPinchGestureRecognizer) {
        
        if(recognizer.state == UIGestureRecognizerState.Ended)
        {
            previousScale = 1.0;
            return;
        }
        
        let newScale:CGFloat  = 1.0 - (previousScale - recognizer.scale);
        
        let currentTransformation:CGAffineTransform  = self.originalImageVw!.transform;
        let newTransform:CGAffineTransform = CGAffineTransformScale(currentTransformation, newScale, newScale);
        self.originalImageVw?.transform = newTransform
        previousScale = recognizer.scale
        
    }
    func adjustImage(recognizer:UIPanGestureRecognizer){
        
        //  let draggedView:UIView = recognizer.view!
        let offset:CGPoint = recognizer.translationInView(self.originalImageVw.superview)
        let center:CGPoint = self.originalImageVw.center;
        self.originalImageVw.center = CGPointMake(center.x + offset.x, center.y + offset.y);
        // Reset translation to zero so on the next `panWasRecognized:` message, the
        // translation will just be the additional movement of the touch since now.
        recognizer.setTranslation(CGPoint.zero, inView:self.originalImageVw.superview)
        
    }
    func screenshot()->UIImage {
        UIGraphicsBeginImageContextWithOptions(self.cropView.bounds.size, false,(self.originalImageVw.image?.scale)!)
        self.cropView.drawViewHierarchyInRect(self.cropView.bounds, afterScreenUpdates:true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
}

