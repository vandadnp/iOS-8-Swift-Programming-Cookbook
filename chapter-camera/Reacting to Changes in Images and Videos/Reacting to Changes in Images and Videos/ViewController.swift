//
//  ViewController.swift
//  Reacting to Changes in Images and Videos
//
//  Created by Vandad Nahavandipoor on 7/11/14.
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

/* Handy extension on UIView to get the width and height */
extension UIView{
  var width: CGFloat{
  return CGRectGetWidth(self.bounds)
  }
  var height: CGFloat{
  return CGRectGetHeight(self.bounds)
  }
}

class ViewController: UIViewController, PHPhotoLibraryChangeObserver {
  
  /* This will represent the newest photo in our library */
  var lastPhoto: PHAsset?
  /* Pressing this button will flip the hidden flag of our asset */
  var buttonChange: UIButton!
  /* The image view that we will use to display the newest photo */
  var imageView: UIImageView?
  
  func photoLibraryDidChange(changeInstance: PHChange!) {
    
    println("Image is changed now")
    
    dispatch_async(dispatch_get_main_queue(), {[weak self] in
      
      let change = changeInstance.changeDetailsForObject(self!.lastPhoto)
      if change != nil{
        self!.lastPhoto = change.objectAfterChanges as? PHAsset
        if change.assetContentChanged{
          self!.retrieveImageForAsset(self!.lastPhoto!)
        }
      }
      })
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    buttonChange = UIButton.buttonWithType(.System) as UIButton
    buttonChange.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
    buttonChange.setTitle("Change photo", forState: .Normal)
    buttonChange.addTarget(self,
      action: "performChangePhoto",
      forControlEvents: .TouchUpInside)
    PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
  }
  
  deinit{
    PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
  }
  
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
  
  func performChangePhoto(){
    
    if let asset = lastPhoto{
      
      /* The hidden flag is a property of the asset hence
      the .Properties value */
      if asset.canPerformEditOperation(.Properties){
        
        /* Do our changes here */
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
          
          /* Flip the hidden flag */
          let request = PHAssetChangeRequest(forAsset: asset)
          request.hidden = !asset.hidden
          }, completionHandler: {[weak self](success: Bool, error: NSError!) in
            
            if success{
              println("Successfully changed the photo")
            } else {
              dispatch_async(dispatch_get_main_queue(), {
                self!.displayAlertWithTitle("Failed",
                  message: "Failed to change the photo properties")
                })
            }
            
          })
        
      } else {
        displayAlertWithTitle("Editing", message: "Could not change the photo")
      }
      
    }
    
  }
  
  func imageFetchingOptions() -> PHImageRequestOptions{
    /* Now retrieve the photo */
    let options = PHImageRequestOptions()
    options.deliveryMode = .HighQualityFormat
    options.resizeMode = .Exact
    options.version = .Current
    return options
  }
  
  func retrieveImageForAsset(asset: PHAsset){
    let imageSize = CGSize(width: view.width, height: view.height)
    
    PHCachingImageManager().requestImageForAsset(asset,
      targetSize: imageSize,
      contentMode: .AspectFit,
      options: imageFetchingOptions(),
      resultHandler: {[weak self] (image: UIImage!,
        info: [NSObject : AnyObject]!) in
        
        dispatch_async(dispatch_get_main_queue(), {
          
          if let theImageView = self!.imageView{
            theImageView.removeFromSuperview()
          }
          if image != nil{
            self!.imageView = UIImageView(image: image)
            if let imageView = self!.imageView{
              imageView.contentMode = .ScaleAspectFit
              imageView.frame = self!.view.bounds
              self!.view.addSubview(imageView)
              self!.buttonChange.center = self!.view.center
              self!.view.addSubview(self!.buttonChange)
            }
            
            
          } else {
            println("No image data came back")
          }
          
          })
        
      })
  }
  
  func retrieveAndDisplayNewestImage(){
    /* Retrieve the items in order of creation date date, newest one
    on top */
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
      ascending: false)]
    
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
    
    if let lastPhoto = assetResults[0] as? PHAsset{
      self.lastPhoto = lastPhoto
      
      retrieveImageForAsset(lastPhoto)
      
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    
    PHPhotoLibrary.requestAuthorization{
      [weak self](status: PHAuthorizationStatus) in
      
      dispatch_async(dispatch_get_main_queue(), {
        
        switch status{
        case .Authorized:
          self!.retrieveAndDisplayNewestImage()
        default:
          self!.displayAlertWithTitle("Access",
            message: "I could not access the photo library")
        }
        })
      
    }
    
  }
  
}

