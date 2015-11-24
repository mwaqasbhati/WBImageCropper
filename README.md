# WBImageCropper

An Innovative Image Cropper made in Swift with which you can crop your profile pictures, background images according to your requirements.

![](https://github.com/mwaqasbhati/WBImageCropper/blob/master/Example/Example/SnapShots/Simulator%20Screen%20Shot%2023-Nov-2015%2C%2010.11.58%20PM.png)
![](https://github.com/mwaqasbhati/WBImageCropper/blob/master/Example/Example/SnapShots/Simulator%20Screen%20Shot%2023-Nov-2015%2C%2010.31.39%20PM.png)

# Installation
* First Download the Example project from Github
* Drag the WBImageCropper into your project Swift project
* Conform to protocol **pickedImageDelegate**
* Add these line where you want to include WBImageCropper like this

**Example:**

Just create a view controller for image cropping and set the delegate.

         let  board:UIStoryboard  = UIStoryboard.init(name:"Main", bundle:nil)
         
         let imageVC:WBImageCropperVC = board.instantiateViewControllerWithIdentifier("WBImageCropperVC") as! WBImageCropperVC`
          
         imageVC.tempFrame = frame // Frame of your cropping rectangle
          
         imageVC.tempImage = image // Image you want to crop
          
         imageVC.cornerRadius = radius // Corner radius If you want a circular cropping 
          
         imageVC.delegate = self // Delegate that you will implement
          
         picker.pushViewController(imageVC, animated:true)

# Delegate

You have to implement two delegates

    func didCancel(){
       print("Cancel is Called")
    }
    func didDone(croppedImage:UIImage){
      print("Your Cropped Image is ready here!")
    } 

 

 
