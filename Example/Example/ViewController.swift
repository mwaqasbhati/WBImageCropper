//
//  ViewController.swift
//  Example
//
//  Created by APPLE on 21/11/2015.
//  Copyright © 2015 Muhammad Waqas Bhati. All rights reserved.
//

import UIKit

enum ImageType {
    case Background
    case Profile
    case BodyBackground
}

class ViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var backGroundImage: UIImageView!
    
    var imageType: ImageType = .Profile

//    private(set) var mainImage: UIImage {
//        set {
//            if imageType == .Background {
//                backGroundImage.image = mainImage
//            } else if imageType == .Profile {
//                profileImage.image = mainImage
//            } else if imageType == .BodyBackground {
//                bodyImage.image = mainImage
//            }
//        }
//        get {
//            if imageType == .Background {
//                return backGroundImage.image ?? UIImage()
//            } else if imageType == .Profile {
//                return profileImage.image ?? UIImage()
//            } else if imageType == .BodyBackground {
//                return bodyImage.image ?? UIImage()
//            }
//            return UIImage()
//        }
//    }
    private(set) var imageView: UIImageView {
        get {
            if imageType == .Background {
                return backGroundImage
            } else if imageType == .Profile {
                return profileImage
            } else if imageType == .BodyBackground {
                return bodyImage
            }
            return UIImageView()
        }
        set {
            let mainImage = imageView.image
            if imageType == .Background {
                backGroundImage.image = mainImage
            } else if imageType == .Profile {
                profileImage.image = mainImage
            } else if imageType == .BodyBackground {
                bodyImage.image = mainImage
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGestureToImages()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageLayout()
    }
    func profileImageLayout() {
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.masksToBounds = true
    }
    func addGestureToImages(){
        
        let profileGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(profileImageTapped(recognizer:)))
        profileImage.addGestureRecognizer(profileGestureRecognizer)
        
        let backGroundGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(backGroundImageTapped(recognizer:)))
        backGroundImage.addGestureRecognizer(backGroundGestureRecognizer)
        
        let bodyGroundGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(bodyGroundImageTapped(recognizer:)))
        bodyImage.addGestureRecognizer(bodyGroundGestureRecognizer)
        
    }
    @objc func backGroundImageTapped(recognizer:UIGestureRecognizer) {
        showOptionsForImage(.Background)
    }
    @objc func profileImageTapped(recognizer:UIGestureRecognizer) {
        showOptionsForImage(.Profile)
    }
    @objc func bodyGroundImageTapped(recognizer:UIGestureRecognizer) {
        showOptionsForImage(.BodyBackground)
    }
    func showOptionsForImage(_ type: ImageType){
        imageType = type
        let imageController = UIImagePickerController()
        imageController.isEditing = false
        imageController.delegate = self
        
        let alert = UIAlertController(title: "Select Photo", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.default, handler:{ (ACTION :UIAlertAction!)in
            imageController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imageController.allowsEditing = true
            self.present(imageController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.default, handler:{ (ACTION :UIAlertAction!)in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                imageController.sourceType = UIImagePickerControllerSourceType.camera
                imageController.allowsEditing = true
                self.present(imageController, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil))
        present(alert, animated: true, completion: nil)
    }
    func gotoNextVCwithImage(image: UIImage, frame: CGRect, picker: UIImagePickerController) {
        let imageVC = WBImageCropperVC(frame, image: image, radius: imageType == .Profile ? profileImage.layer.cornerRadius: 0.0)
        imageVC.delegate = self
        picker.pushViewController(imageVC, animated:true)
    }
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        gotoNextVCwithImage(image: image,frame: imageView.frame, picker:picker)
    }
    
}

extension ViewController: pickedImageDelegate {
    
    func pickedImageDidFinish(_ image: UIImage) {
         imageView.image = image
    }
}

