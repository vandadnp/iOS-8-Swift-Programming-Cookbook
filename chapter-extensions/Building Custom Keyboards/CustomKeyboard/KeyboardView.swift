//
//  KeyboardView.swift
//  Building Custom Keyboards
//
//  Created by Vandad Nahavandipoor on 7/27/14.
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

/* Create an extension on UIView that allows us to animate the tapped
state of the buttons */
extension UIView{
  func scaleByFactor(factor: CGFloat, animationDuration: NSTimeInterval){
    UIView.animateWithDuration(animationDuration, animations: {[weak self] in
      let strongSelf = self!
      strongSelf.transform = CGAffineTransformMakeScale(factor, factor)
      })
  }
  
  func resetScalingWithAnimationDuration(duration: NSTimeInterval){
    scaleByFactor(1.0, animationDuration: duration)
  }
}

/* This is a button. The superclass is a view to allow you
to do more with the button if you want to */
class KeyboardButton : UIView{
  
  /* Instantiate the button and place it right
  in the center of the view */
  var button: UIButton!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(buttonTitle: String){
    super.init(frame: CGRectZero)
    button = UIButton(frame: bounds)
    button.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    addSubview(button)
    button.setTitle(buttonTitle, forState: .Normal)
    button.addTarget(self, action: "enlargeForTouchDown",
      forControlEvents: .TouchDown)
    button.addTarget(self, action: "goToNormalSize",
      forControlEvents: .AllEvents ^ (.TouchDown))
  }
  
}

/* This is the actual keyboard view, which is the container */
class KeyboardView: UIView {
  
  /* Define our variables here */
  var buttons = [KeyboardButton]()
  let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  var nextKeyboardButton: KeyboardButton!
  let buttonWidth = 45.0 as CGFloat
  let buttonHeight = 45.0 as CGFloat
  
  /* Define our contextual document proxy that will give us information
  about the context in which our keyboard will be displayed and gives
  us capability to interact with the component that is showing the keyboard */
  weak var textDocumentProxy: UITextDocumentProxy?{
  willSet(newValue){
    if let proxy = newValue{
      if proxy.keyboardAppearance! == .Dark{
        backgroundColor = UIColor.darkGrayColor()
      } else {
        backgroundColor = UIColor.lightGrayColor()
      }
    }
  }
  }
  
  /* Position the button properly now */
  override func layoutSubviews() {
    super.layoutSubviews()
    
    var xPosition = 0.0 as CGFloat
    var yPosition = 0.0 as CGFloat
    
    for button in buttons{
      button.frame = CGRect(x: xPosition,
        y: yPosition,
        width: buttonWidth,
        height: buttonHeight)
      
      xPosition += buttonWidth
      
      if xPosition + buttonWidth >= bounds.size.width{
        xPosition = 0.0
        yPosition += buttonHeight
      }
      
    }
  }
  
  /* Handle the tap and the backspace buttons */
  func handleTapOnButton(button: UIButton){
    let buttonText = button.titleForState(.Normal)
    if let proxy = textDocumentProxy{
      proxy.insertText(buttonText)
    }
  }
  
  func handleBackSpace(){
    if let proxy = textDocumentProxy{
      proxy.deleteBackward()
    }
  }
  
  /* Add our buttons to the keyboard
  also add the backspace button and the Next Keyboard buttons */
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.lightGrayColor()
    
    /* Create all the buttons */
    for character in characters{
      let keyboardButton = KeyboardButton(buttonTitle: "\(character)")
      buttons.append(keyboardButton)
      keyboardButton.button.addTarget(self, action: "handleTapOnButton:",
        forControlEvents: .TouchUpInside)
      addSubview(keyboardButton)
    }
    
    /* Create the backspace button */
    let backspaceButton = KeyboardButton(buttonTitle: "<")
    backspaceButton.button.addTarget(self, action: "handleBackSpace",
      forControlEvents: .TouchUpInside)
    buttons.append(backspaceButton)
    addSubview(backspaceButton)
    
    /* Create the next button */
    nextKeyboardButton = KeyboardButton(buttonTitle: "->")
    nextKeyboardButton.button.addTarget(self, action: "goToNextKeyboard",
      forControlEvents: .TouchUpInside)
    buttons.append(nextKeyboardButton)
    addSubview(nextKeyboardButton)
    
  }
  
  
}
