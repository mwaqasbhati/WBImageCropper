//
//  ViewController.swift
//  Example
//
//  Created by APPLE on 21/11/2015.
//  Copyright © 2015 Muhammad Waqas Bhati. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        super.viewDidLayoutSubviews()
        self.profileImage.layer.borderWidth = 2.0
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
        self.profileImage.layer.masksToBounds = true
        
    }
    func addGestureToImages(){
        
        let profileGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(profileImageTapped(recognizer:)))
        self.profileImage.addGestureRecognizer(profileGestureRecognizer)
        
        let backGroundGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(backGroundImageTapped(recognizer:)))
        self.backGroundImage.addGestureRecognizer(backGroundGestureRecognizer)
        
        let bodyGroundGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(bodyGroundImageTapped(recognizer:)))
        self.bodyImage.addGestureRecognizer(bodyGroundGestureRecognizer)
        
    }
    
    @objc func profileImageTapped(recognizer:UIGestureRecognizer){
        
        check = 2
        self.showOptions()
    }
    @objc func backGroundImageTapped(recognizer:UIGestureRecognizer){
        check = 1
        self.showOptions()
    }
    @objc func bodyGroundImageTapped(recognizer:UIGestureRecognizer){
        check = 3
        self.showOptions()
    }
    func showOptions(){
        
        let imageController = UIImagePickerController()
        imageController.isEditing = false
        imageController.delegate = self;
        
        let alert = UIAlertController(title: "Select Photo", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.default, handler:{ (ACTION :UIAlertAction!)in
            imageController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imageController.allowsEditing = true
            self.present(imageController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.default, handler:{ (ACTION :UIAlertAction!)in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                imageController.sourceType = UIImagePickerControllerSourceType.camera
                imageController.allowsEditing = true
                self.present(imageController, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (ACTION :UIAlertAction!)in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func gotoNextVCwithImage(image:UIImage,frame:CGRect,picker:UIImagePickerController){
        let  board:UIStoryboard  = UIStoryboard.init(name:"Main", bundle:nil)
        let imageVC:WBImageCropperVC = board.instantiateViewController(withIdentifier: "WBImageCropperVC") as! WBImageCropperVC
        imageVC.tempFrame = frame
        imageVC.tempImage = image
        if check == 2{
         imageVC.cornerRadius = self.profileImage.layer.cornerRadius
        }
        imageVC.delegate = self
        picker.pushViewController(imageVC, animated:true)
    }
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        if check == 1 {
            
            self.gotoNextVCwithImage(image: image,frame: self.backGroundImage.frame,picker:picker)
        }
        else if check == 2 {
            self.gotoNextVCwithImage(image: image,frame: self.profileImage.frame,picker: picker)
            
        }
        else if check == 3 {
            self.gotoNextVCwithImage(image: image,frame: self.bodyImage.frame,picker: picker)
            
        }
        
    }
    
}

extension ViewController: pickedImageDelegate {
    
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
    func didCancel(){
        
    }
    
}

