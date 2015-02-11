//
//  ViewController.swift
//  Constructing Resizable Images
//
//  Created by Vandad Nahavandipoor on 6/24/14.
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
    
    /* Instantiate the button */
    let button = UIButton.buttonWithType(.Custom) as! UIButton
    button.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
    
    
    /* Set the title of the button */
    button.setTitle("Stretched Image on Button", forState: .Normal)
    
    /* Adjust the font for our text */
    button.titleLabel!.font = UIFont.systemFontOfSize(15)
    
    /* Construct the stretchable image */
    let image = UIImage(named: "Button")!.resizableImageWithCapInsets(
      UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
    
    /* Set the background image of the button */
    button.setBackgroundImage(image, forState: .Normal)
    button.center = self.view.center
    
    self.view.addSubview(button)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

