# WBImageCropper

[![Version](https://img.shields.io/cocoapods/v/WBImageCropper.svg?style=flat)](https://cocoapods.org/pods/WBImageCropper)
[![License](https://img.shields.io/cocoapods/l/WBImageCropper.svg?style=flat)](https://cocoapods.org/pods/WBImageCropper)
[![Platform](https://img.shields.io/cocoapods/p/WBImageCropper.svg?style=flat)](https://cocoapods.org/pods/WBImageCropper)


WBImageCropper works for all type of input cropping mask and is implemented in Swift.*


## About

WBImageCropper will provide you image editing & cropping functionality by just calling a 2 line to code. It made things easy that was never before.

## Background

I have used many cropping tools but this library provides cropping stuff very user friendly.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

- First Create a WBImageCropper Object with Image and Cropping Mask and then confirm to it's delegate
  
```swift
let croppingView = WBImageCropperVC(CGRect(x: 0, y: view.frame.size.height/2, width: view.frame.size.width, height: 200), image: UIImage(named: "world")!)
croppingView.delegate = self
present(croppingView, animated: true, completion: nil)
```
### ImageCropperDelegate 

```swift
func pickedImageDidFinish(_ image: UIImage)
func pickedImageDidCancel(_ image: UIImage?)
```

|             Square Mask         |         Rectangle Mask          |
|---------------------------------|------------------------------|
|![Demo](https://github.com/mwaqasbhati/WBImageCropper/blob/master/screenshots/square.png)|![Demo](https://github.com/mwaqasbhati/WBImageCropper/blob/master/screenshots/rectangle.png)|
## Requirements

- iOS 9.4
- Swift 4.1

## Installation

### Manually

Download the Code and Copy the file -> `WBImageCropper.swift` into your project. That's it.

### CocoaPods

WBImageCropper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WBImageCropper'
```

## Author

mwaqasbhati, m.waqas.bhati@hotmail.com

## License

WBImageCropper is available under the MIT license. See the LICENSE file for more info.
