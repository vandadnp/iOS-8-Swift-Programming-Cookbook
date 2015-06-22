//
//  ViewController.swift
//  Performing Non-UI Related Tasks
//
//  Created by Vandad Nahavandipoor on 7/3/14.
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
//  func printFrom1To1000(){
//
//    for counter in 0..<1000{
//      print("Counter = \(counter) - Thread = \(NSThread.currentThread())")
//    }
//
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    dispatch_sync(queue, printFrom1To1000)
//    dispatch_sync(queue, printFrom1To1000)
//
//  }
//
//}
//
//// 2
//import UIKit
//
//class ViewController: UIViewController {
//
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//
//    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    dispatch_async(queue, {
//
//      dispatch_sync(queue, {
//        /* Download the image here */
//        })
//
//      dispatch_sync(dispatch_get_main_queue(), {
//        /* Show the image to the user here on the main queue */
//        })
//
//      })
//  }
//
//}
//
////3
//import UIKit
//
//class ViewController: UIViewController {
//  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    dispatch_async(queue, {[weak self] in
//      
//      var image: UIImage?
//      
//      dispatch_sync(queue, {
//        /* Download the image here */
//        
//        /* Put your own URL here */
//        let urlAsString = "https://www.apple.com/iphone-5s/features/" +
//        "images/wireless_hero.jpg"
//        
//        let url = NSURL(string: urlAsString)
//        let urlRequest = NSURLRequest(URL: url!)
//        var downloadError: NSError?
//        
//        let imageData: NSData?
//        do {
//          imageData = try NSURLConnection.sendSynchronousRequest(urlRequest,
//            returningResponse: nil)
//        } catch let error as NSError {
//          downloadError = error
//          imageData = nil
//        } catch {
//          fatalError()
//        }
//        
//        if let error = downloadError{
//          print("Error happened = \(error)")
//        } else if let imageData = imageData{
//          
//          if imageData.length > 0{
//            image = UIImage(data: imageData)
//            /* Now we have the image */
//          } else {
//            print("No data could get downloaded from the URL")
//          }
//          
//        }
//        
//      })
//      
//      dispatch_sync(dispatch_get_main_queue(), {
//        /* Show the image to the user here on the main queue */
//        
//        if let theImage = image{
//          let imageView = UIImageView(frame: self!.view.bounds)
//          imageView.contentMode = .ScaleAspectFit
//          imageView.image = theImage
//          self!.view.addSubview(imageView)
//        }
//        
//      })
//      
//      })
//  }
//  
//}
//
////4
import UIKit

class ViewController: UIViewController {

  func fileLocation() -> String?{

    /* Get the document folder(s) */
    let folders = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
      .UserDomainMask,
      true) as [String]

    /* Did we find anything? */
    if folders.count == 0{
      return nil
    }

    /* Get the first folder */
    let documentsFolder = folders[0]

    /* Append the filename to the end of the documents path */
    return documentsFolder.stringByAppendingPathComponent("list.txt")

  }

  func hasFileAlreadyBeenCreated() -> Bool{
    let fileManager = NSFileManager()
    if let theLocation = fileLocation(){
      return fileManager.fileExistsAtPath(theLocation)
    }
    return false
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    let concurrentQueue =
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    /* If we have not already saved an array of 10,000
    random numbers to the disk before, generate these numbers now
    and then save them to the disk in an array */
    dispatch_async(concurrentQueue, {[weak self] in

      let numberOfValuesRequired = 10000


      if self!.hasFileAlreadyBeenCreated() == false{
        dispatch_sync(concurrentQueue, {

          var arrayOfRandomNumbers = [Int]()

          for _ in 0..<numberOfValuesRequired{
            let randomNumber = Int(arc4random())
            arrayOfRandomNumbers.append(randomNumber)
          }

          /* Now let's write the array to disk */
          let array = arrayOfRandomNumbers as NSArray
          array.writeToFile(self!.fileLocation()!, atomically: true)

          })
      }

      var randomNumbers: NSMutableArray?

      /* Read the numbers from disk and sort them in an
      ascending fashion */
      dispatch_sync(concurrentQueue, {
        /* If the file has now been created, we have to read it */
        if self!.hasFileAlreadyBeenCreated(){
          randomNumbers = NSMutableArray(
            contentsOfFile: self!.fileLocation()!)

          /* Now sort the numbers */
          randomNumbers!.sortUsingComparator({
            (obj1: AnyObject!, obj2: AnyObject!) -> NSComparisonResult in
            let number1 = obj1 as! NSNumber
            let number2 = obj2 as! NSNumber
            return number1.compare(number2)
            })
        }
        })


      dispatch_async(dispatch_get_main_queue(), {
        if let numbers = randomNumbers{

          if numbers.count > 0{
            /* Refresh the UI here using the numbers in the
            randomNumbers array */
            print("The sorted array was read back from disk = \(numbers)")
          } else {
            print("The numbers array is emtpy")
          }

        }
        })

      })

  }

}
