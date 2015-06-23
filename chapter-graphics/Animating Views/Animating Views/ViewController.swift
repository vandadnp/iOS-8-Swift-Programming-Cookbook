//
//  ViewController.swift
//  Animating Views
//
//  Created by Vandad Nahavandipoor on 6/25/14.
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

class ViewController: UIViewController {
  
  /* 1 */
//  var safariImageView:UIImageView
//  let safariImage = UIImage(named: "Safari")
//  
//  override init(nibName nibNameOrNil: String!,
//    bundle nibBundleOrNil: NSBundle!) {
//    safariImageView = UIImageView(image: safariImage)
//    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//  }
//
//  required init(coder aDecoder: NSCoder) {
//    safariImageView = UIImageView(image: safariImage)
//    super.init(coder: aDecoder)
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    /* Just set the size to make the image smaller */
//    self.safariImageView.frame = CGRect(x: 0, y: 30, width: 100, height: 100)
//    
//    self.view.addSubview(self.safariImageView)
//    
//  }
//
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    /* Start from top left corner */
//    self.safariImageView.frame = CGRect(x: 0, y: 30, width: 100, height: 100)
//    let endRect = CGRect(x: self.view.bounds.size.width - 100,
//      y: self.view.bounds.size.height - 100,
//      width: 100,
//      height: 100)
//    
//    UIView.animateWithDuration(5.0, animations: {
//      self.safariImageView.frame = endRect
//      }, completion: {
//        completed in
//        print("Finished the animation")
//      })
//  }
//  
//  /* 2 */
//  var safariImageView1:UIImageView
//  var safariImageView2:UIImageView
//  
//  var bottomRightRect:CGRect{
//  get{
//    return CGRect(
//      x: self.view.bounds.size.width - 100,
//      y: self.view.bounds.size.height - 100,
//      width: 100,
//      height: 100)
//  }
//  }
//  
//  let topLeftRect = CGRect(x: 0, y: 0, width: 100, height: 100)
//  let image = UIImage(named: "Safari")
//  
//  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
//    safariImageView1 = UIImageView(image: image)
//    safariImageView2 = UIImageView(image: image)
//    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//  }
//  
//  required init(coder aDecoder: NSCoder) {
//    safariImageView1 = UIImageView(image: image)
//    safariImageView2 = UIImageView(image: image)
//    super.init(coder: aDecoder)
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    safariImageView1.frame = topLeftRect
//    safariImageView2.frame = bottomRightRect
//    self.view.addSubview(safariImageView1)
//    self.view.addSubview(safariImageView2)
//  }
//  
//  func startTopLeftImageViewAnimation(){
//    
//    /* Start from top left corner */
//    safariImageView1.frame = topLeftRect
//    
//    safariImageView1.alpha = 1
//    
//    UIView.animateWithDuration(3, animations: {
//      self.safariImageView1.frame = self.bottomRightRect
//      self.safariImageView1.alpha = 0
//      }, completion: {
//      finished in
//        self.safariImageView1.removeFromSuperview()
//      })
//
//  }
//  
//  func startBottomRightViewAnimationAfterDelay(paramDelay: CGFloat){
//    
//    /* Start from bottom right corner */
//    safariImageView2.frame = bottomRightRect
//    
//    safariImageView2.alpha = 1
//    
//    UIView.animateWithDuration(3, delay: NSTimeInterval(paramDelay),
//      options: UIViewAnimationOptions(rawValue: 0),
//      animations: {
//        self.safariImageView2.frame = self.topLeftRect
//        self.safariImageView2.alpha = 0
//      },
//      completion: {finished in
//        self.safariImageView2.removeFromSuperview()
//    })
//    
//  }
//  
//  override func viewDidAppear(animated: Bool){
//    super.viewDidAppear(animated)
//    
//    startTopLeftImageViewAnimation()
//    startBottomRightViewAnimationAfterDelay(2)
//    
//  }
//
//  /* 3 */
//  var safariImageView:UIImageView
//  let image = UIImage(named: "Safari")
//  
//  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
//    safariImageView = UIImageView(image: image)
//    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//  }
//  
//  required init(coder aDecoder: NSCoder) {
//    safariImageView = UIImageView(image: image)
//    super.init(coder: aDecoder)
//  }
//  
//  override func viewDidLoad() {
//    self.view.addSubview(safariImageView)
//  }
//  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    safariImageView.center = self.view.center
//    
//    /* Begin the animation */
//    
//    UIView.animateWithDuration(5, animations: {
//        self.safariImageView.transform =
//          CGAffineTransformMakeRotation(
//            CGFloat((90.0 * M_PI) / 180.0))
//      }) {finished in
//        UIView.animateWithDuration(5, animations: {
//          self.safariImageView.transform =
//          CGAffineTransformIdentity
//        })
//    }
//  
//  }
//
//  /* 4 */
  var safariImageView:UIImageView
  let image = UIImage(named: "Safari")
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    safariImageView = UIImageView(image: image)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init(coder aDecoder: NSCoder) {
    safariImageView = UIImageView(image: image)
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(safariImageView)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    /* Place the image view at the center of
    the view of this view controller */
    safariImageView.center = self.view.center
    
    /* Make sure no translation is applied to this image view */
    safariImageView.transform = CGAffineTransformIdentity;
    
    
    /* Make the image view twice as large in
    width and height */
    
    /* Begin the animation */
    UIView.animateWithDuration(5, animations: {
      /* Rotate the image view 90 degrees */
      self.safariImageView.transform =
        CGAffineTransformMakeScale(2, 2)
    })
  }

  
}

