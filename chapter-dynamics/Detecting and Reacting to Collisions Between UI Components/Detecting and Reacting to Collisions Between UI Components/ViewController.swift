//
//  ViewController.swift
//  Detecting and Reacting to Collisions Between UI Components
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

///* 1 */
//import UIKit
//
//class ViewController: UIViewController {
//  var squareViews = [AnyObject]()
//  var animator: UIDynamicAnimator?
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var squareViews = [UIDynamicItem]()
//  var animator: UIDynamicAnimator?
//  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    let colors = [UIColor.redColor(), UIColor.greenColor()]
//    
//    /* Create the views */
//    var currentCenterPoint = view.center
//    let eachViewSize = CGSize(width: 50, height: 50)
//    for counter in 0..<2{
//      
//      let newView = UIView(frame:
//        CGRect(x: 0,
//          y: 0,
//          width: eachViewSize.width,
//          height: eachViewSize.height))
//      
//      newView.backgroundColor = colors[counter]
//      newView.center = currentCenterPoint
//      currentCenterPoint.y += eachViewSize.height + 10
//      squareViews.append(newView)
//      view.addSubview(newView)
//      
//    }
//    
//    animator = UIDynamicAnimator(referenceView: self.view)
//    
//    /* Create gravity */
//    let gravity = UIGravityBehavior(items: squareViews)
//    animator!.addBehavior(gravity)
//  
//    /* Create collision detection */
//    let collision = UICollisionBehavior(items: squareViews)
//    collision.translatesReferenceBoundsIntoBoundary = true
//    animator!.addBehavior(collision)
//  
//  }
//  
//}

//// 3 
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var squareViews = [UIDynamicItem]()
//  var animator: UIDynamicAnimator?
//  
//  override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    let colors = [UIColor.redColor(), UIColor.greenColor()]
//    
//    /* Create the views */
//    var currentCenterPoint = view.center
//    let eachViewSize = CGSize(width: 50, height: 50)
//    for counter in 0..<2{
//      
//      let newView = UIView(frame:
//        CGRect(x: 0,
//          y: 0,
//          width: eachViewSize.width,
//          height: eachViewSize.height))
//      
//      newView.backgroundColor = colors[counter]
//      newView.center = currentCenterPoint
//      currentCenterPoint.y += eachViewSize.height + 10
//      squareViews.append(newView)
//      view.addSubview(newView)
//      
//    }
//    
//    animator = UIDynamicAnimator(referenceView: self.view)
//    
//    /* Create gravity */
//    let gravity = UIGravityBehavior(items: squareViews)
//    animator!.addBehavior(gravity)
//    
//    /* Create collision detection */
//    let collision = UICollisionBehavior(items: squareViews)
//    
//    let fromPoint = CGPoint(x: 0, y: view.bounds.size.height - 100)
//    
//    let toPoint = CGPoint(x: view.bounds.size.width,
//      y: view.bounds.size.height - 100)
//    
//    collision.addBoundaryWithIdentifier("bottomBoundary",
//      fromPoint: fromPoint,
//      toPoint: toPoint)
//    
//    animator!.addBehavior(collision)
//    
//  }
//  
//}

///* 4 */
import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
  
  let bottomBoundary = "bottomBoundary"
  var squareViews = [UIDynamicItem]()
  var animator: UIDynamicAnimator?
  
  func collisionBehavior(behavior: UICollisionBehavior,
    beganContactForItem item: UIDynamicItem,
    withBoundaryIdentifier identifier: NSCopying?,
    atPoint p: CGPoint){
      
      if identifier as? String == bottomBoundary{
        UIView.animateWithDuration(1, animations: {
          let view = item as! UIView
          view.backgroundColor = UIColor.redColor()
          view.alpha = 0
          view.transform = CGAffineTransformMakeScale(2, 2)
          }, completion:{(finished: Bool) in
            let view = item as! UIView
            behavior.removeItem(item)
            view.removeFromSuperview()
          })
      }
      
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let colors = [UIColor.redColor(), UIColor.greenColor()]
    
    /* Create the views */
    var currentCenterPoint = CGPoint(x: view.center.x, y: 0)
    let eachViewSize = CGSize(width: 50, height: 50)
    for counter in 0..<2{
      
      let newView = UIView(frame:
        CGRect(x: 0,
          y: 0,
          width: eachViewSize.width,
          height: eachViewSize.height))
      
      newView.backgroundColor = colors[counter]
      newView.center = currentCenterPoint
      currentCenterPoint.y += eachViewSize.height + 10
      squareViews.append(newView)
      view.addSubview(newView)
      
    }
    
    animator = UIDynamicAnimator(referenceView: self.view)
    
    /* Create gravity */
    let gravity = UIGravityBehavior(items: squareViews)
    animator!.addBehavior(gravity)
    
    /* Create collision detection */
    let collision = UICollisionBehavior(items: squareViews)
    
    let fromPoint = CGPoint(x: 0, y: view.bounds.size.height - 100)
    
    let toPoint = CGPoint(x: view.bounds.size.width,
      y: view.bounds.size.height - 100)
    
    collision.addBoundaryWithIdentifier(bottomBoundary,
      fromPoint: fromPoint,
      toPoint: toPoint)
    
    collision.collisionDelegate = self
    
    animator!.addBehavior(collision)
    
  }
  
}
