//
//  ViewController.swift
//  Adding Blur Effects to Your Views
//
//  Created by Vandad Nahavandipoor on 6/26/14.
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
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Note: An image has already been placed on the view of this controller */
    
    /* First, create the blur effect with the "Light" style.
    All the styles are defined in UIBlurEffectStyle */
    let blurEffect = UIBlurEffect(style: .Light)
    
    /* Then create the effect view, using the blur effect that
    we just created. The effect is of type UIVisualEffect */
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame.size = CGSize(width: 200, height: 200)
    blurView.center = view.center
    
    /* Then eventually we will add this view to our controller */
    view.addSubview(blurView)
    
  }

}

