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

class WBImageCropperVC:UIViewController {
    
    var delegate:pickedImageDelegate!=nil
    var previousScale:CGFloat = 0.0
    var cornerRadius:CGFloat = 0.0
    var tempFrame:CGRect = CGRect.zero
    var tempImage:UIImage = UIImage.init()
    var transView:WBImageCropperView!
    var cropView: UIView!
    var originalImageVw: UIImageView!
    var cancelBtn:UIButton!
    var doneBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCropView()
        originalImageVw.isUserInteractionEnabled = true
        navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        originalImageVw.image = tempImage
        originalImageVw.frame =  CGRect(x: 0,y: 0,width: tempImage.size.width,height: tempImage.size.height)
        var transparentRects:NSArray
        if self.cornerRadius == 0.0 {
            transparentRects = NSArray.init(objects:NSValue(cgRect:self.tempFrame))
        }
        else{
            transparentRects = []
        }
        transView = WBImageCropperView.init(frame:self.view.frame, backgroundColor:UIColor.init(white:0.0, alpha:0.5), rects:transparentRects)
        view.insertSubview(transView, aboveSubview:cropView)
        addGestureToView()
        initializeButton()
        
    }
    func initializeCropView(){
        
        self.cropView = UIView.init(frame:CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
        self.originalImageVw = UIImageView.init()
        self.cropView.addSubview(originalImageVw)
        self.view.addSubview(cropView)
    }
    func initializeButton(){
       
        cancelBtn = UIButton.init(type:UIButtonType.custom)
        cancelBtn.setTitle("Cancel", for:UIControlState.normal)
        cancelBtn.addTarget(self, action:#selector(cancelBtnPressed), for:UIControlEvents.touchUpInside)
        doneBtn = UIButton.init(type:UIButtonType.custom)
        doneBtn.setTitle("Done", for:UIControlState.normal)
        doneBtn.addTarget(self, action:#selector(doneBtnPressed), for:UIControlEvents.touchUpInside)
        cancelBtn.sizeToFit()
        doneBtn.sizeToFit()
        self.view.addSubview(cancelBtn)
        self.view.addSubview(doneBtn)
        
    }
    @objc func cancelBtnPressed(){
        
        self.delegate.didCancel()
        self.dismiss(animated: true) { () -> Void in
            
        }
        
    
    }
    @objc func doneBtnPressed(){
        let image = self.screenshot()
        self.delegate.didDone(croppedImage: image)
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    override func viewDidLayoutSubviews() {
        
        cancelBtn.frame = CGRect(x: 10.0,y: 20.0,width: 60.0,height: 30.0)
        doneBtn.frame = CGRect(x: self.view.frame.size.width-70.0,y: 20.0,width: 60.0,height: 30.0)
        
        self.cropView.frame = tempFrame
        self.cropView.center = self.view.center
        
        self.cropView.layer.borderWidth = 2.0
        self.cropView.layer.borderColor = UIColor.white.cgColor
        
        self.cropView.layer.masksToBounds = true
        self.cropView.clipsToBounds = false
        
        if self.cornerRadius == 0.0 {
            self.transView.rectsArray = NSArray.init(objects:NSValue(cgRect:self.cropView.frame))
            self.transView.draw(self.transView.frame)
            
        }
        else{
            self.transView.circles = NSArray.init(objects:NSValue(cgRect:self.cropView.frame))
            self.transView.draw(self.transView.frame)
            self.cropView.layer.cornerRadius = self.cropView.frame.size.height/2
            
        }
        
    }
    func addGestureToView(){
        
        let panGesture = UIPanGestureRecognizer(target:self, action:#selector(adjustImage(recognizer:)))
        panGesture.delegate = self
        self.transView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer.init(target:self, action:#selector(scalePiece(recognizer:)))
        pinchGesture.delegate = self
        self.transView.addGestureRecognizer(pinchGesture)
        
//        let rotateGesture = UIRotationGestureRecognizer(target: self, action: ("handleRotate:"))
//        self.transView.addGestureRecognizer(rotateGesture)
//        rotateGesture.delegate = self
        
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
    @objc func scalePiece(recognizer:UIPinchGestureRecognizer) {
        
        if(recognizer.state == UIGestureRecognizerState.ended)
        {
            previousScale = 1.0;
            return;
        }
        
        let newScale:CGFloat  = 1.0 - (previousScale - recognizer.scale);
        
        let currentTransformation:CGAffineTransform  = self.originalImageVw!.transform;
        let newTransform:CGAffineTransform = currentTransformation.scaledBy(x: newScale, y: newScale)//CGAffineTransformScale(currentTransformation, newScale, newScale);
        self.originalImageVw?.transform = newTransform
        previousScale = recognizer.scale
        
    }
    @objc func adjustImage(recognizer:UIPanGestureRecognizer){
        
        //  let draggedView:UIView = recognizer.view!
        let offset:CGPoint = recognizer.translation(in: self.originalImageVw.superview)
        let center:CGPoint = self.originalImageVw.center;
        self.originalImageVw.center = CGPoint(x: center.x + offset.x,y: center.y + offset.y);
        // Reset translation to zero so on the next `panWasRecognized:` message, the
        // translation will just be the additional movement of the touch since now.
        recognizer.setTranslation(CGPoint.zero, in:self.originalImageVw.superview)
        
    }
    func screenshot()->UIImage {
        UIGraphicsBeginImageContextWithOptions(self.cropView.bounds.size, false,(self.originalImageVw.image?.scale)!)
        self.cropView.drawHierarchy(in: self.cropView.bounds, afterScreenUpdates:true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image;
    }
    
}

extension WBImageCropperVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

