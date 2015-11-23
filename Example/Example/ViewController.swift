//
//  ViewController.swift
//  Example
//
//  Created by APPLE on 21/11/2015.
//  Copyright © 2015 Muhammad Waqas Bhati. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,pickedImageDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var backGroundImage: UIImageView!
    
    var check:NSInteger = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addGestureToImages()
    }
    override func viewDidLayoutSubviews() {
        self.profileImage.layer.borderWidth = 2.0
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
        self.profileImage.layer.masksToBounds = true
        
    }
    func addGestureToImages(){
        
        let profileGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageTapped:"))
        self.profileImage.addGestureRecognizer(profileGestureRecognizer)
        
        let backGroundGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("backGroundImageTapped:"))
        self.backGroundImage.addGestureRecognizer(backGroundGestureRecognizer)
        
        let bodyGroundGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("bodyGroundImageTapped:"))
        self.bodyImage.addGestureRecognizer(bodyGroundGestureRecognizer)
        
    }
    
    func profileImageTapped(recognizer:UIGestureRecognizer){
        
        check = 2
        self.showOptions()
    }
    func backGroundImageTapped(recognizer:UIGestureRecognizer){
        check = 1
        self.showOptions()
    }
    func bodyGroundImageTapped(recognizer:UIGestureRecognizer){
        check = 3
        self.showOptions()
    }
    func showOptions(){
        
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self;
        
        let alert = UIAlertController(title: "Select Photo", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imageController.allowsEditing = true
            self.presentViewController(imageController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                imageController.allowsEditing = true
                self.presentViewController(imageController, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ (ACTION :UIAlertAction!)in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    func gotoNextVCwithImage(image:UIImage,frame:CGRect,picker:UIImagePickerController){
        let  board:UIStoryboard  = UIStoryboard.init(name:"Main", bundle:nil)
        let imageVC:WBImageCropperVC = board.instantiateViewControllerWithIdentifier("WBImageCropperVC") as! WBImageCropperVC
        imageVC.tempFrame = frame
        imageVC.tempImage = image
        if check == 2{
         imageVC.cornerRadius = self.profileImage.layer.cornerRadius
        }
        imageVC.delegate = self
        picker.pushViewController(imageVC, animated:true)
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if check == 1 {
            
            self.gotoNextVCwithImage(image,frame: self.backGroundImage.frame,picker:picker)
        }
        else if check == 2 {
            self.gotoNextVCwithImage(image,frame: self.profileImage.frame,picker: picker)
            
        }
        else if check == 3 {
            self.gotoNextVCwithImage(image,frame: self.bodyImage.frame,picker: picker)
            
        }
      //  self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func didCancel(){
    
    }
    func didDone(croppedImage:UIImage){
        
        if check == 1 {
         
            self.backGroundImage.image = croppedImage
        
        }
        else if check == 2 {
            self.profileImage.image = croppedImage
        }
        else if check == 3 {
            self.bodyImage.image = croppedImage
        }
        
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

