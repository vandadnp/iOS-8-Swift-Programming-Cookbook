//
//  ViewController.swift
//  Animating Your UI Components With a Push
//
//  Created by Vandad Nahavandipoor on 6/30/14.
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
//  var squareView: UIView?
//  var animator: UIDynamicAnimator?
//  var pushBehavior: UIPushBehavior?
//}

/* 2 */
import UIKit

class ViewController: UIViewController {
  var squareView: UIView?
  var animator: UIDynamicAnimator?
  var pushBehavior: UIPushBehavior?
  
  func handleTap(tap: UITapGestureRecognizer){
    
    /* Get the angle between the center of the square view
    and the tap point */
    
    let tapPoint = tap.locationInView(view)
    let squareViewCenterPoint = self.squareView!.center
    
    /* Calculate the angle between the center point of the square view and
    the tap point to find out the angle of the push
    
    Formula for detecting the angle between two points is:
    
    arc tangent 2((p1.x - p2.x), (p1.y - p2.y)) */
    let deltaX = tapPoint.x - squareViewCenterPoint.x
    let deltaY = tapPoint.y - squareViewCenterPoint.y
    let angle = atan2(deltaY, deltaX)
    
    pushBehavior!.angle = angle
    
    /* Use the distance between the tap point and the center of our square
    view to calculate the magnitude of the push
    
    Distance formula is:
    square root of ((p1.x - p2.x)^2 + (p1.y - p2.y)^2) */
    let distanceBetweenPoints =
      sqrt(pow(tapPoint.x - squareViewCenterPoint.x, 2.0) +
        pow(tapPoint.y - squareViewCenterPoint.y, 2.0))
    
    pushBehavior!.magnitude = distanceBetweenPoints / 200.0
    
  }
  
  func createSmallSquareView(){
    squareView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    if let theSquareView = squareView{
      theSquareView.backgroundColor = UIColor.greenColor()
      theSquareView.center = view.center
      view.addSubview(theSquareView)
    }
  }
  
  func createGestureRecognizer(){
    let tapGestureRecognizer =
    UITapGestureRecognizer(target: self, action: "handleTap:")
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func createAnimatorAndBehaviors(){
    animator = UIDynamicAnimator(referenceView: view)
    
    if let theSquareView = squareView{
      /* Create collision detection */
      let collision = UICollisionBehavior(items: [theSquareView])
      collision.translatesReferenceBoundsIntoBoundary = true
      pushBehavior = UIPushBehavior(items: [theSquareView], mode: .Continuous)
      animator!.addBehavior(collision)
      animator!.addBehavior(pushBehavior)
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    createGestureRecognizer()
    createSmallSquareView()
    createAnimatorAndBehaviors()
  }
  
}