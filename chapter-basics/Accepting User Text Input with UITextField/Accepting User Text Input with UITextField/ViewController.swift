//
//  ViewController.swift
//  Accepting User Text Input with UITextField
//
//  Created by Vandad Nahavandipoor on 6/29/14.
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
//  
//  var textField: UITextField?
//  
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//  
//  var textField: UITextField?
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 31))
//    
//    if let theTextField = self.textField{
//      theTextField.borderStyle = .RoundedRect
//      
//      theTextField.contentVerticalAlignment = .Center
//      
//      theTextField.textAlignment = .Center
//      
//      theTextField.text = "Sir Richard Branson"
//      theTextField.center = view.center
//      view.addSubview(theTextField)
//    }
//    
//  }
//  
//}

/* 3 */
//import UIKit
//
//class ViewController: UIViewController, UITextFieldDelegate {
//  
//  <# the rest of your code goes here #>
//  
//}

/* 4 */
//import UIKit
//
//class ViewController: UIViewController, UITextFieldDelegate {
//
//  var textField: UITextField?
//  var label: UILabel?
//  
//}

/* 5 */
//import UIKit
//
//class ViewController: UIViewController, UITextFieldDelegate {
//
//  var textField: UITextField?
//  var label: UILabel?
//  
//  func calculateAndDisplayTextFieldLengthWithText(text: String){
//    
//    var characterOrCharacters = "Character"
//    if countElements(text) != 1{
//      characterOrCharacters += "s"
//    }
//    
//    let stringLength = countElements(text)
//    
//    label!.text = "\(stringLength) \(characterOrCharacters)"
//    
//  }
//  
//  
//  func textField(paramTextField: UITextField!,
//    shouldChangeCharactersInRange range: NSRange,
//    replacementString string: String!) -> Bool{
//      
//      let text = paramTextField.text as NSString
//      
//      let wholeText =
//      text.stringByReplacingCharactersInRange(
//        range, withString: string)
//      
//      calculateAndDisplayTextFieldLengthWithText(wholeText)
//      
//      return true
//      
//  }
//  
//  func textFieldShouldReturn(paramTextField: UITextField!) -> Bool{
//    paramTextField.resignFirstResponder()
//    return true
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    textField = UITextField(frame:
//      CGRect(x: 38, y: 30, width: 220, height: 31))
//    
//    if let theTextField = textField{
//      theTextField.delegate = self
//      theTextField.borderStyle = .RoundedRect
//      theTextField.contentVerticalAlignment = .Center
//      theTextField.textAlignment = .Center
//      theTextField.text = "Sir Richard Branson"
//      view.addSubview(theTextField)
//      
//    }
//    
//    label = UILabel(frame: CGRect(x: 38, y: 61, width: 220, height: 31))
//    view.addSubview(label!)
//    calculateAndDisplayTextFieldLengthWithText(textField!.text)
//    
//  }
//
//}

/* 6 */
//import UIKit
//
//class ViewController: UIViewController {
//
//  var textField: UITextField?
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    textField = UITextField(frame:
//      CGRect(x: 38, y: 30, width: 220, height: 31))
//    
//    if let theTextField = textField{
//      theTextField.borderStyle = .RoundedRect
//      theTextField.contentVerticalAlignment = .Center
//      theTextField.textAlignment = .Center
//      theTextField.placeholder = "Enter your text here..."
//      view.addSubview(theTextField)
//    }
//
//  }
//
//}

/* 7 */
import UIKit

class ViewController: UIViewController {
  
  var textField: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textField = UITextField(frame:
      CGRect(x: 38, y: 30, width: 220, height: 31))
    
    if let theTextField = textField{
      theTextField.borderStyle = .RoundedRect
      theTextField.contentVerticalAlignment = .Center
      theTextField.textAlignment = .Left
      theTextField.placeholder = "Enter your text here..."
      
    let currencyLabel = UILabel(frame: CGRectZero)
    currencyLabel.text = NSNumberFormatter().currencySymbol
    currencyLabel.font = theTextField.font
    currencyLabel.textAlignment = .Right
    currencyLabel.sizeToFit()
    /* Give more width to the label so that it aligns properly on the
      text field's left view, when the label's text itself is right aligned
    */
    currencyLabel.frame.size.width += 10
    theTextField.leftView = currencyLabel
    theTextField.leftViewMode = .Always
    view.addSubview(theTextField)
    }
    
  }
  
}