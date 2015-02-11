//
//  ViewController.swift
//  Loading Web Pages with UIWebView
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
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let webView = UIWebView(frame: view.bounds)
//    let htmlString = "<br/>iOS <strong>Programming</strong>"
//    webView.loadHTMLString(htmlString, baseURL: nil)
//    view.addSubview(webView)
//
//  }
//
//}

/* 2 */
//import UIKit
//
//class ViewController: UIViewController {
//
//  /* Hide the status bar to give all the screen real estate */
//  override func prefersStatusBarHidden() -> Bool {
//    return true
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let webView = UIWebView(frame: view.bounds)
//    webView.scalesPageToFit = true
//    view.addSubview(webView)
//
//    let url = NSURL(string: "http://www.apple.com")
//    let request = NSURLRequest(URL: url!)
//
//    webView.loadRequest(request)
//
//    view.addSubview(webView)
//
//  }
//
//}

/* 3 */
import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
  
  func webViewDidStartLoad(webView: UIWebView){
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func webViewDidFinishLoad(webView: UIWebView){
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError){
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Render the web view under the status bar */
    var frame = view.bounds
    frame.origin.y = UIApplication.sharedApplication().statusBarFrame.height
    frame.size.height -= frame.origin.y
    
    let webView = UIWebView(frame: frame)
    webView.delegate = self
    webView.scalesPageToFit = true
    view.addSubview(webView)
    
    let url = NSURL(string: "http://www.apple.com")
    let request = NSURLRequest(URL: url!)
    
    webView.loadRequest(request)
    
    view.addSubview(webView)
    
  }
  
}