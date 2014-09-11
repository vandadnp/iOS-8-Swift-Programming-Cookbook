//
//  ViewController.swift
//  Adding a Dynamic Snap Effect to Your UI Components
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
//  var snapBehavior: UISnapBehavior?
//}

/* 2 */
import UIKit

class ViewController: UIViewController {
  var squareView: UIView?
  var animator: UIDynamicAnimator?
  var snapBehavior: UISnapBehavior?
  
  func createGestureRecognizer(){
    
    let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
    view.addGestureRecognizer(tap)
    
  }
  
  func createSmallSquareView(){
    squareView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    squareView!.backgroundColor = UIColor.greenColor()
    squareView!.center = view.center
    view.addSubview(squareView!)
    
  }
  
  func createAnimatorAndBehaviors(){
    animator = UIDynamicAnimator(referenceView: view)
    
    let collision = UICollisionBehavior(items: [squareView!])
    collision.translatesReferenceBoundsIntoBoundary = true
    
    animator!.addBehavior(collision)
    
    /* For now, snap the square view to its current center */
    snapBehavior = UISnapBehavior(item: squareView!,
      snapToPoint: squareView!.center)
    /* Medium oscillation */
    snapBehavior!.damping = 0.5
    
    animator!.addBehavior(snapBehavior!)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    self.createGestureRecognizer()
    self.createSmallSquareView()
    self.createAnimatorAndBehaviors()
    
  }
  
func handleTap(tap: UITapGestureRecognizer){
  
  /* Get the angle between the center of the square view
  and the tap point */
  
  let tapPoint = tap.locationInView(view)
  
  if let theSnap = snapBehavior{
    animator!.removeBehavior(theSnap)
  }
  
  snapBehavior = UISnapBehavior(item: squareView!, snapToPoint: tapPoint)
  /* Medium oscillation */
  snapBehavior!.damping = 0.5
  animator!.addBehavior(snapBehavior!)
}
  
}