//
//  ViewController.swift
//  Searching for and Retrieving Images and Videos
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

import UIKit
import Photos

class ViewController: UIViewController {
  
  /* Just a little method to help us display alert dialogs to the user */
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    
    PHPhotoLibrary.requestAuthorization{
      [weak self](status: PHAuthorizationStatus) in
      
      dispatch_async(dispatch_get_main_queue(), {
        
        switch status{
        case .Authorized:
          self!.retrieveImage()
        default:
          self!.displayAlertWithTitle("Access",
            message: "I could not access the photo library")
        }
        })
      
    }
    
  }
  
  func retrieveImage() {
    super.viewDidLoad()
    
    /* Retrieve the items in order of modification date, ascending */
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "modificationDate",
      ascending: true)]
    
    /* Then get an object of type PHFetchResult that will contain
    all our image assets */
    let assetResults = PHAsset.fetchAssetsWithMediaType(.Image,
      options: options)
    
    if assetResults == nil{
      println("Found no results")
      return
    } else {
      println("Found \(assetResults.count) results")
    }
    
    let imageManager = PHCachingImageManager()
    
    assetResults.enumerateObjectsUsingBlock{(object: AnyObject!,
      count: Int,
      stop: UnsafeMutablePointer<ObjCBool>) in
      
      if object is PHAsset{
        let asset = object as! PHAsset
        
        let imageSize = CGSize(width: asset.pixelWidth,
          height: asset.pixelHeight)
        
        /* For faster performance, and maybe degraded image */
        let options = PHImageRequestOptions()
        options.deliveryMode = .FastFormat
        
        imageManager.requestImageForAsset(asset,
          targetSize: imageSize,
          contentMode: .AspectFill,
          options: options,
          resultHandler: {(image: UIImage!,
            info: [NSObject : AnyObject]!) in
            
            /* The image is now available to us */
            
          })
      }
      
    }
    
  }
  
}

/* 2 */
//import UIKit
//import Photos
//import AVFoundation
//
//class ViewController: UIViewController {
//  
//  var player: AVPlayer!
//  
//  /* Just a little method to help us display alert dialogs to the user */
//  func displayAlertWithTitle(title: String, message: String){
//    let controller = UIAlertController(title: title,
//      message: message,
//      preferredStyle: .Alert)
//    
//    controller.addAction(UIAlertAction(title: "OK",
//      style: .Default,
//      handler: nil))
//    
//    presentViewController(controller, animated: true, completion: nil)
//    
//  }
//  
//  func retrieveAndPlayVideo(){
//    /* Retrieve the items in order of modification date, ascending */
//    let options = PHFetchOptions()
//    options.sortDescriptors = [NSSortDescriptor(key: "modificationDate",
//      ascending: true)]
//    
//    /* Then get an object of type PHFetchResult that will contain
//    all our video assets */
//    let assetResults = PHAsset.fetchAssetsWithMediaType(.Video,
//      options: options)
//    
//    if assetResults == nil{
//      println("Found no results")
//      return
//    } else {
//      println("Found \(assetResults.count) results")
//    }
//    
//    /* Get the first video */
//    let object: AnyObject = assetResults[0]
//    
//    if let asset = object as? PHAsset{
//      
//      /* We want to be able to display a video even if it currently
//      resides only on the cloud and not on the device */
//      let options = PHVideoRequestOptions()
//      options.deliveryMode = .Automatic
//      options.networkAccessAllowed = true
//      options.version = .Current
//      options.progressHandler = {(progress: Double,
//        error: NSError!,
//        stop: UnsafeMutablePointer<ObjCBool>,
//        info: [NSObject : AnyObject]!) in
//        
//        /* You can write your code here that shows a progress bar to the
//        user and then using the progress parameter of this block object, you
//        can update your progress bar. */
//        
//      }
//      
//      /* Now get the video */
//      PHCachingImageManager().requestAVAssetForVideo(asset,
//        options: options,
//        resultHandler: {[weak self](asset: AVAsset!,
//          audioMix: AVAudioMix!,
//          info: [NSObject : AnyObject]!) in
//          
//          /* This result handler is performed on a random thread but
//          we want to do some UI work so let's switch to the main thread */
//          
//          dispatch_async(dispatch_get_main_queue(), {
//            
//            /* Did we get the URL to the video? */
//            if let asset = asset as? AVURLAsset{
//              let player = AVPlayer(URL: asset.URL)
//              /* Create the layer now */
//              let layer = AVPlayerLayer(player: player)
//              layer.frame = self!.view.bounds
//              self!.view.layer.addSublayer(layer)
//              player.play()
//            } else {
//              println("This is not a URL asset. Cannot play")
//            }
//            
//            })
//          
//        })
//      
//    }
//  }
//  
//  override func viewDidAppear(animated: Bool) {
//    
//    super.viewDidAppear(animated)
//    
//    PHPhotoLibrary.requestAuthorization{
//      [weak self](status: PHAuthorizationStatus) in
//      
//      dispatch_async(dispatch_get_main_queue(), {
//        
//        switch status{
//        case .Authorized:
//          self!.retrieveAndPlayVideo()
//        default:
//          self!.displayAlertWithTitle("Access",
//            message: "I could not access the photo library")
//        }
//        })
//      
//    }
//    
//  }
//
//}


