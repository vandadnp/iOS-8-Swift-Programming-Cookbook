//
//  ViewController.swift
//  Editing Images and Videos Right on the Device
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
import OpenGLES

class ViewController: UIViewController {
  
  /* These two values are our way of telling the Photos framework about
  the identifier of the changes that we are going to make to the photo */
  let editFormatIdentifier = NSBundle.mainBundle().bundleIdentifier!
  /* Just an application specific editing version */
  let editFormatVersion = "0.1"
  /* This is our filter name. We will use this for our Core Image filter */
  let filterName = "CIColorPosterize"
  
  /* This turns an image into its NSData representation */
  func dataFromCiImage(image: CIImage) -> NSData{
    let glContext = EAGLContext(API: .OpenGLES2)
    let context = CIContext(EAGLContext: glContext)
    let imageRef = context.createCGImage(image, fromRect: image.extent())
    let image = UIImage(CGImage: imageRef, scale: 1.0, orientation: .Up)
    return UIImageJPEGRepresentation(image, 1.0)
  }
  
  /* A little handy method that allows us to perform a block
  object on the main thread */
  func performOnMainThread(block: dispatch_block_t){
    dispatch_async(dispatch_get_main_queue(), block)
  }
  
  func editAsset(asset: PHAsset){
    
    /* Can we handle previous edits on this asset? */
    let requestOptions = PHContentEditingInputRequestOptions()
    requestOptions.canHandleAdjustmentData = {
      [weak self] (data: PHAdjustmentData!) -> Bool in
      /* Yes, but only if they are our edits */
      if data.formatIdentifier == self!.editFormatIdentifier &&
        data.formatVersion == self!.editFormatVersion{
          return true
      } else {
        return false
      }
    }
    
  /* Now ask the system if we are allowed to edit the given asset */
  asset.requestContentEditingInputWithOptions(requestOptions,
    completionHandler: {[weak self](input: PHContentEditingInput!,
      info: [NSObject : AnyObject]!) in
        
        /* Get the required information from the asset */
        let url = input.fullSizeImageURL
        let orientation = input.fullSizeImageOrientation
        
        /* Retrieve an instance of CIImage to apply our filter to */
        let inputImage =
        CIImage(contentsOfURL: url,
          options: nil).imageByApplyingOrientation(orientation)
        
        /* Apply the filter to our image */
        let filter = CIFilter(name: self!.filterName)
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage
        
        /* Get the data of our edited image */
        let editedImageData = self!.dataFromCiImage(outputImage)
        
        /* The results of editing our image are encapsulated here */
        let output = PHContentEditingOutput(contentEditingInput: input)
        /* Here we are saving our edited image to the URL that is dictated
        by the content editing output class */
        editedImageData.writeToURL(output.renderedContentURL,
          atomically: true)
        output.adjustmentData =
          PHAdjustmentData(formatIdentifier: self!.editFormatIdentifier,
            formatVersion: self!.editFormatVersion,
            data: self!.filterName.dataUsingEncoding(NSUTF8StringEncoding,
              allowLossyConversion: false))
        
      /* Now perform our changes */
      PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        /* This is the change object and its output is the output object
        that we created previously */
        let change = PHAssetChangeRequest(forAsset: asset)
        change.contentEditingOutput = output
        }, completionHandler: {[weak self] (success: Bool, error: NSError!) in
          
          self!.performOnMainThread{
            if success{
              self!.displayAlertWithTitle("Succeeded",
                message: "Successfully edited the image")
            } else {
              self!.displayAlertWithTitle("Failed",
                message: "Could not edit the image. Error = \(error)")
            }
          }
          
        })
        
        
      })
    
  }
  
  /* After this method retrieves the newest image from the user's assets
  library, it will attempt to edit it */
  func retrieveNewestImage() {
    
    /* Retrieve the items in order of creation date date, newest one
    on top */
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
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
    
    if let asset = assetResults[0] as? PHAsset{
      editAsset(asset)
    }
    
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
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    
    PHPhotoLibrary.requestAuthorization{
      [weak self](status: PHAuthorizationStatus) in
      
      dispatch_async(dispatch_get_main_queue(), {
        
        switch status{
        case .Authorized:
          self!.retrieveNewestImage()
        default:
          self!.displayAlertWithTitle("Access",
            message: "I could not access the photo library")
        }
        })
      
    }
    
  }
  
}

