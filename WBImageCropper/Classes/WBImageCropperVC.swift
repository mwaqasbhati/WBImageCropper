//
//  WBImageCropperVC.swift
//  Example
//
//  Created by APPLE on 21/11/2015.
//  Copyright © 2015 Muhammad Waqas Bhati. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocol
public protocol ImageCropperDelegate: class {
    /*
     This delegate method will be called when user want to cancel the cropping.
     */
    func pickedImageDidCancel(_ image: UIImage?)
    /*
     This method will provide you the cropped image after applying masking onto the image. The class which will implement this menthod will get the cropped image.
     */
    func pickedImageDidFinish(_ image: UIImage)
}
extension ImageCropperDelegate {
    // default implementation of the cancel method
    func pickedImageDidCancel(_ image: UIImage?) { }
}

//MARK: ViewController Class
open class WBImageCropperVC: UIViewController {
    
    //MARK: Instance Variables
    public weak var delegate: ImageCropperDelegate?
    var transView: WBImageCropperView!
    var previousScale = CGFloat(0.0)
    var cornerRadius = CGFloat(0.0)
    var inputMask = CGRect.zero
    var inputImage = UIImage()
    var cropView: UIView!
    var originalImageView: UIImageView!
    var cancelButton: UIButton!
    var doneButton: UIButton!
    
    //MARK: Initializer
    public convenience init(_ inputMask: CGRect, image: UIImage, radius: CGFloat = CGFloat(0.0)) {
        self.init()
        self.inputMask = inputMask
        self.inputImage = image
        self.cornerRadius = radius
    }
    
    //MARK: ViewController Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        initializeCropView()
        originalImageView.isUserInteractionEnabled = true
        navigationController?.isNavigationBarHidden = true
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originalImageView.image = inputImage
        originalImageView.frame =  CGRect(x: 0,y: 0,width: inputImage.size.width,height: inputImage.size.height)
        
        var transparentRects = [NSValue]()
        if cornerRadius == 0.0 {
            transparentRects = [NSValue(cgRect:inputMask)]
        }
        transView = WBImageCropperView(frame:view.frame, backgroundColor:UIColor(white:0.0, alpha:0.5), rects:transparentRects)
        view.insertSubview(transView, aboveSubview:cropView)
        addGestureToView()
        initializeButton()
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelButton.frame = CGRect(x: 10.0,y: 30.0,width: 60.0,height: 30.0)
        doneButton.frame = CGRect(x: view.frame.size.width-70.0,y: 30.0,width: 60.0,height: 30.0)
        
        cropView.frame = inputMask
        cropView.center = view.center
        
        cropView.layer.borderWidth = 2.0
        cropView.layer.borderColor = UIColor.white.cgColor
        
        cropView.layer.masksToBounds = true
        cropView.clipsToBounds = false
        
        if cornerRadius == 0.0 {
            transView.rectsArray = [NSValue(cgRect: cropView.frame)]
            transView.draw(transView.frame)
        } else {
            transView.circles = [NSValue(cgRect: cropView.frame)]
            transView.draw(transView.frame)
            cropView.layer.cornerRadius = cornerRadius//cropView.frame.size.height/2
        }
    }
    
    //MARK: Helper Methods
    private func initializeCropView() {
        cropView = UIView(frame:CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
        originalImageView = UIImageView()
        cropView.addSubview(originalImageView)
        view.addSubview(cropView)
    }
    private func initializeButton() {
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action:#selector(cancelButtonPressed), for: .touchUpInside)
        doneButton = UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action:#selector(doneButtonPressed), for: .touchUpInside)
        cancelButton.sizeToFit()
        doneButton.sizeToFit()
        view.addSubview(cancelButton)
        view.addSubview(doneButton)
    }
    @objc func cancelButtonPressed() {
        delegate?.pickedImageDidCancel(nil)
        dismiss(animated: true, completion: nil)
    }
    @objc func doneButtonPressed() {
        let image = screenshot()
        delegate?.pickedImageDidFinish(image)
        dismiss(animated: true, completion: nil)
    }
    
    func addGestureToView(){
        
        let panGesture = UIPanGestureRecognizer(target:self, action:#selector(adjustImage(recognizer:)))
        panGesture.delegate = self
        transView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target:self, action:#selector(scalePiece(recognizer:)))
        pinchGesture.delegate = self
        transView.addGestureRecognizer(pinchGesture)
        
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
    //MARK: Desture Handling Methods
    @objc func scalePiece(recognizer:UIPinchGestureRecognizer) {
        
        if(recognizer.state == .ended) {
            previousScale = 1.0
            return
        }
        let newScale  = 1.0 - (previousScale - recognizer.scale)
        let currentTransformation  = originalImageView!.transform
        let newTransform = currentTransformation.scaledBy(x: newScale, y: newScale)//CGAffineTransformScale(currentTransformation, newScale, newScale);
        originalImageView?.transform = newTransform
        previousScale = recognizer.scale
    }
    @objc func adjustImage(recognizer:UIPanGestureRecognizer){
        
        //  let draggedView:UIView = recognizer.view!
        let offset = recognizer.translation(in: originalImageView.superview)
        let center = originalImageView.center
        originalImageView.center = CGPoint(x: center.x + offset.x,y: center.y + offset.y)
        // Reset translation to zero so on the next `panWasRecognized:` message, the
        // translation will just be the additional movement of the touch since now.
        recognizer.setTranslation(CGPoint.zero, in: originalImageView.superview)
    }
    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(cropView.bounds.size, false,(originalImageView.image?.scale)!)
        self.cropView.drawHierarchy(in: cropView.bounds, afterScreenUpdates:true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

//MARK: UIGestureRecognizerDelegate
extension WBImageCropperVC: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: WBImageCropperView
class WBImageCropperView: UIView {
    
    //MARK: Instance Variables
    var rectsArray = [NSValue]()
    var circles = [NSValue]()
    var backColor = UIColor()
    
    //MARK: Initializers
    required init(frame:CGRect,backgroundColor:UIColor,rects: [NSValue]) {
        rectsArray = rects
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = backgroundColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Override Functions
    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)
        
        // clear the background in the given rectangles
        for holeRectValue in rectsArray {
            let holeRect = holeRectValue.cgRectValue
            let holeRectIntersection = holeRect.intersection( rect )
            UIColor.clear.setFill()
            UIRectFill(holeRectIntersection)
        }
        for aRect in circles {
            let context = UIGraphicsGetCurrentContext()
            if(aRect.cgRectValue.intersects(rect)) {
                context?.addEllipse(in: aRect.cgRectValue)
                context?.clip()
                guard context != nil else {
                    return
                }
                context!.clear(aRect.cgRectValue)
                context!.setFillColor( UIColor.clear.cgColor)
                context!.fill( aRect.cgRectValue)
            }
        }
        
    }
    
}

