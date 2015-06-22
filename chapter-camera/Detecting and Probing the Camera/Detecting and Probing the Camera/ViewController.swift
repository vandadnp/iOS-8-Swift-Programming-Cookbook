//
//  ViewController.swift
//  Detecting and Probing the Camera
//
//  Created by Vandad Nahavandipoor on 7/10/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//
//  These example codes are written for O'Reilly's iOS 8 Swift Programming Cookbook
//  If you use these solutions in your apps, you can give attribution to
//  Vandad Nahavandipoor for his work. Feel free to visit my blog
//  at http://vandadnp.wordpress.com for daily tips and tricks in Swift
//  and Objective-C and various other programming languages.
//  
//  You can purchase "iOS 8 Swift Programming Cookbook" from
//  the following URL:
//  http://shop.oreilly.com/product/0636920034254.do
//
//  If you have any questions, you can contact me directly
//  at vandad.np@gmail.com
//  Similarly, if you find an error in these sample codes, simply
//  report them to O'Reilly at the following URL:
//  http://www.oreilly.com/catalog/errata.csp?isbn=0636920034254

/* 1 */
//import UIKit
//
//class ViewController: UIViewController {
//                            
//  func isCameraAvailable() -> Bool{
//    
//    return UIImagePickerController.isSourceTypeAvailable(.Camera)
//  
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    print("Camera is ", appendNewline: false)
//    
//    if isCameraAvailable() == false{
//      print("not ", appendNewline: false)
//    }
//    
//    print("available")
//    
//  }
//
//}

/* 2 */
//import UIKit
//import MobileCoreServices
//
//class ViewController: UIViewController {
//  
//  func cameraSupportsMedia(mediaType: String,
//    sourceType: UIImagePickerControllerSourceType) -> Bool{
//      
//      
//      let availableMediaTypes =
//      UIImagePickerController.availableMediaTypesForSourceType(sourceType)
//      
//      guard let types = availableMediaTypes else {
//        return false
//      }
//      
//      for type in types{
//        if type == mediaType{
//          return true
//        }
//      }
//      
//      return false
//  }
//  
//  func doesCameraSupportShootingVideos() -> Bool{
//    return cameraSupportsMedia(kUTTypeMovie as String, sourceType: .Camera)
//  }
//  
//  func doesCameraSupportTakingPhotos() -> Bool{
//    return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    if doesCameraSupportTakingPhotos(){
//      print("The camera supports taking photos")
//    } else {
//      print("The camera does not support taking photos")
//    }
//    
//    if doesCameraSupportShootingVideos(){
//      print("The camera supports shooting videos")
//    } else {
//      print("The camera does not support shooting videos")
//    }
//    
//  }
//  
//}
//
/* 3 */
import UIKit
import MobileCoreServices

class ViewController: UIViewController {

  func cameraSupportsMedia(mediaType: String,
    sourceType: UIImagePickerControllerSourceType) -> Bool{

      let availableMediaTypes =
      UIImagePickerController.availableMediaTypesForSourceType(sourceType) as
        [String]?
      
      if let types = availableMediaTypes{
        for type in types{
          if type == mediaType{
            return true
          }
        }
      }

      return false
  }

  func doesCameraSupportShootingVideos() -> Bool{
    return cameraSupportsMedia(kUTTypeMovie as String, sourceType: .Camera)
  }

  func doesCameraSupportTakingPhotos() -> Bool{
    return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
  }
  
  func isFrontCameraAvailable() -> Bool{
    return UIImagePickerController.isCameraDeviceAvailable(.Front)
  }
  
  func isRearCameraAvailable() -> Bool{
    return UIImagePickerController.isCameraDeviceAvailable(.Rear)
  }
  
  func isFlashAvailableOnFrontCamera() -> Bool{
    return UIImagePickerController.isFlashAvailableForCameraDevice(.Front)
  }
  
  func isFlashAvailableOnRearCamera() -> Bool{
    return UIImagePickerController.isFlashAvailableForCameraDevice(.Front)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if isFrontCameraAvailable(){
      print("The front camera is available")
      if isFlashAvailableOnFrontCamera(){
        print("The front camera is equipped with a flash")
      } else {
        print("The front camera is not equipped with a flash")
      }
    } else {
      print("The front camera is not available")
    }
    
    if isRearCameraAvailable(){
      print("The rear camera is available")
      if isFlashAvailableOnRearCamera(){
        print("The rear camera is equipped with a flash")
      } else {
        print("The rear camera is not equipped with a flash")
      }
    } else {
      print("The rear camera is not available")
    }
    
    if doesCameraSupportTakingPhotos(){
      print("The camera supports taking photos")
    } else {
      print("The camera does not support taking photos")
    }
    
    if doesCameraSupportShootingVideos(){
      print("The camera supports shooting videos")
    } else {
      print("The camera does not support shooting videos")
    }

  }

}


