//
//  ViewController.swift
//  Attaching Multiple Dynamic Items to Each Other
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

import UIKit

class ViewController: UIViewController {
  
  var squareView: UIView?
  var squareViewAnchorView: UIView?
  var anchorView: UIView?
  var animator: UIDynamicAnimator?
  var attachmentBehavior: UIAttachmentBehavior?
  
  func createSmallSquareView(){
    
    squareView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    if let theSquareView = squareView{
      theSquareView.backgroundColor = UIColor.greenColor()
      theSquareView.center = view.center
      
      squareViewAnchorView = UIView(frame:
        CGRect(x: 60, y: 0, width: 20, height: 20))
      
      squareViewAnchorView!.backgroundColor = UIColor.brownColor()
      theSquareView.addSubview(squareViewAnchorView!)
      view.addSubview(theSquareView)
    }
    
  }
  
  func createAnchorView(){
    
    anchorView = UIView(frame: CGRect(x: 120, y: 120, width: 20, height: 20))
    anchorView!.backgroundColor = UIColor.redColor()
    view.addSubview(anchorView!)
    
  }
  
  func createGestureRecognizer(){
    let panGestureRecognizer = UIPanGestureRecognizer(target: self,
      action: "handlePan:")
    view.addGestureRecognizer(panGestureRecognizer)
  }
  
  func createAnimatorAndBehaviors(){
    
    animator = UIDynamicAnimator(referenceView: view)
    
    /* Create collision detection */
    let collision = UICollisionBehavior(items: [squareView!])
    collision.translatesReferenceBoundsIntoBoundary = true
    
    attachmentBehavior = UIAttachmentBehavior(item: squareView!,
      offsetFromCenter: UIOffset(horizontal: 30, vertical: -40),
      attachedToAnchor: anchorView!.center)
    
    animator!.addBehavior(collision)
    animator!.addBehavior(attachmentBehavior!)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    createGestureRecognizer()
    createSmallSquareView()
    createAnchorView()
    createAnimatorAndBehaviors()
    
  }
  
  func handlePan(pan: UIPanGestureRecognizer){
  
    let tapPoint = pan.locationInView(view)
    attachmentBehavior!.anchorPoint = tapPoint
    anchorView!.center = tapPoint
    
  }
  
}

