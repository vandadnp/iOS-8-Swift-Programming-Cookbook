//
//  PhotoEditingViewController.swift
//  PosterizeExtension
//
//  Created by vandad on 217//14.
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
import PhotosUI
import OpenGLES

class PhotoEditingViewController: UIViewController,
PHContentEditingController {
  
  /* An image view on the screen that first shows the original
  image to the user and after we are done applying our edits to the image,
  it will show the edited image */
  @IBOutlet weak var imageView: UIImageView!
  
  /* The input that we will be given by the system */
  var input: PHContentEditingInput!
  
  /* We give our edits to the user in this way */
  var output: PHContentEditingOutput!
  
  /* The name of the image filter that we will apply to the input image */
  let filterName = "CIColorPosterize"
  
  /* These two values are our way of telling the Photos framework about
  the identifier of the changes that we are going to make to the photo */
  let editFormatIdentifier = NSBundle.mainBundle().bundleIdentifier!
  
  /* Just an application specific editing version */
  let editFormatVersion = "0.1"
  
  /* A queue that will execute our edits in the background */
  let operationQueue = NSOperationQueue()
  
  let shouldShowCancelConfirmation: Bool = true

  /* This turns an image into its NSData representation */
  func dataFromCiImage(image: CIImage) -> NSData{
    let glContext = EAGLContext(API: .OpenGLES2)
    let context = CIContext(EAGLContext: glContext)
    let imageRef = context.createCGImage(image, fromRect: image.extent())
    let image = UIImage(CGImage: imageRef, scale: 1.0, orientation: .Up)
    return UIImageJPEGRepresentation(image, 1.0)
  }
  
  /* This takes the input and converts it to the output. The output
  has our posterized content saved inside it */
  func posterizedImageForInput(input: PHContentEditingInput) ->
    PHContentEditingOutput{
      
      /* Get the required information from the asset */
      let url = input.fullSizeImageURL
      let orientation = input.fullSizeImageOrientation
      
      /* Retrieve an instance of CIImage to apply our filter to */
      let inputImage =
      CIImage(contentsOfURL: url,
        options: nil).imageByApplyingOrientation(orientation)
      
      /* Apply the filter to our image */
      let filter = CIFilter(name: filterName)
      filter.setDefaults()
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      let outputImage = filter.outputImage
      
      /* Get the data of our edited image */
      let editedImageData = dataFromCiImage(outputImage)
      
      /* The results of editing our image are encapsulated here */
      let output = PHContentEditingOutput(contentEditingInput: input)
      /* Here we are saving our edited image to the URL that is dictated
      by the content editing output class */
      editedImageData.writeToURL(output.renderedContentURL,
        atomically: true)
      
      output.adjustmentData =
        PHAdjustmentData(formatIdentifier: editFormatIdentifier,
          formatVersion: editFormatVersion,
          data: filterName.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false))
      
      return output
      
  }
  
  /* We just want to work with the original image */
  func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
    return false
  }
  
  /* This is a closure that we will submit to our operation queue */
  func editingOperation(){
    
    output = posterizedImageForInput(input)
    
    dispatch_async(dispatch_get_main_queue(), {[weak self] in
      let strongSelf = self!
      
      let data = NSData(contentsOfURL: strongSelf.output.renderedContentURL,
        options: .DataReadingMappedIfSafe,
        error: nil)
      
      let image = UIImage(data: data!)
      
      strongSelf.imageView.image = image
      })
  }
  
  func startContentEditingWithInput(
    contentEditingInput: PHContentEditingInput?,
    placeholderImage: UIImage) {
      
      imageView.image = placeholderImage
      input = contentEditingInput
      
      /* Start the editing in the background */
      let block = NSBlockOperation(block: editingOperation)
      operationQueue.addOperation(block)
      
  }
  
  func finishContentEditingWithCompletionHandler(
    completionHandler: ((PHContentEditingOutput!) -> Void)!) {
      /* Report our output */
      completionHandler(output)
  }
  
  /* The user cancelled the editing process */
  func cancelContentEditing() {
    /* Make sure we stop our operation here */
    operationQueue.cancelAllOperations()
  }
  
}
