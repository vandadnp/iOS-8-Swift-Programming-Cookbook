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

class KeyboardButton : UIView{
  
  var button: UIButton!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(buttonTitle: String){
    super.init(frame: CGRectZero)
    button = UIButton(frame: bounds)
    button.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    addSubview(button)
    button.setTitle(buttonTitle, forState: .Normal)
    button.addTarget(self, action: "enlargeForTouchDown",
      forControlEvents: .TouchDown)
    button.addTarget(self, action: "goToNormalSize",
      forControlEvents: UIControlEvents(rawValue: UIControlEvents.AllEvents.rawValue ^ UIControlEvents.TouchDown.rawValue))
  }
  
  func goToNormalSize(){
    self.resetScalingWithAnimationDuration(0.1)
  }
  
  func enlargeForTouchDown(){
    self.scaleByFactor(3.0, animationDuration: 0.1)
  }
  
}

class KeyboardView: UIView {
  
  var buttons = [KeyboardButton]()
  let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  var nextKeyboardButton: KeyboardButton!
  let buttonWidth = 45.0 as CGFloat
  let buttonHeight = 45.0 as CGFloat
  
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
  
  func handleTapOnButton(button: UIButton){
    let buttonText = button.titleForState(.Normal)
    if let text = buttonText{
      if let proxy = textDocumentProxy{
        proxy.insertText(text)
      }
    }
  }
  
  func handleBackSpace(){
    if let proxy = textDocumentProxy{
      proxy.deleteBackward()
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.lightGrayColor()
    
    /* Create all the buttons */
    for character in characters.characters{
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
