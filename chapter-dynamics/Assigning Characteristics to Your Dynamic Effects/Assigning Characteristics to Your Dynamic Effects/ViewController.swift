//
//  ViewController.swift
//  Assigning Characteristics to Your Dynamic Effects
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
//  var animator: UIDynamicAnimator?
//}

/* 2 */
import UIKit

class ViewController: UIViewController {
  var animator: UIDynamicAnimator?
  
  func newViewWithCenter(center: CGPoint, backgroundColor: UIColor) -> UIView{
    
    let newView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    newView.backgroundColor = backgroundColor
    newView.center = center
    return newView
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let topView = newViewWithCenter(CGPoint(x: 100, y: 0),
      backgroundColor: UIColor.greenColor())
    
    let bottomView = newViewWithCenter(CGPoint(x: 100, y: 50),
      backgroundColor: UIColor.redColor())
    
    view.addSubview(topView)
    view.addSubview(bottomView)
    
    animator = UIDynamicAnimator(referenceView: view)
    
    /* Create gravity */
    let gravity = UIGravityBehavior(items: [topView, bottomView])
    animator!.addBehavior(gravity)
    
    /* Create collision detection */
    let collision = UICollisionBehavior(items: [topView, bottomView])
    collision.translatesReferenceBoundsIntoBoundary = true
    
    animator!.addBehavior(collision)
    
    /* Now specify the elasticity of the items */
    let moreElasticItem = UIDynamicItemBehavior(items: [bottomView])
    moreElasticItem.elasticity = 1
    
    let lessElasticItem = UIDynamicItemBehavior(items: [topView])
    lessElasticItem.elasticity = 0.5
    animator!.addBehavior(moreElasticItem)
    animator!.addBehavior(lessElasticItem)
    
  }
  
}