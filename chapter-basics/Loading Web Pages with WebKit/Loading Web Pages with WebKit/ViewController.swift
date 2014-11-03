//
//  ViewController.swift
//  Loading Web Pages with WebKit
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
//import WebKit
//
//class ViewController: UIViewController, WKNavigationDelegate {
//  var webView: WKWebView?
//  
//  /* Start the network activity indicator when the web view is loading */
//  func webView(webView: WKWebView!,
//    didStartProvisionalNavigation navigation: WKNavigation!){
//      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//  }
//  
//  /* Stop the network activity indicator when the loading finishes */
//  func webView(webView: WKWebView!,
//    didFinishNavigation navigation: WKNavigation!){
//      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//  }
//  
//  /* Do not allow links to be tapped */
//  func webView(webView: WKWebView!,
//    decidePolicyForNavigationAction navigationAction: WKNavigationAction!,
//    decisionHandler: ((WKNavigationActionPolicy) -> Void)!){
//      
//      /* Do not allow links to be tapped */
//      if navigationAction.navigationType == .LinkActivated{
//        
//        decisionHandler(.Cancel)
//        
//        let alertController = UIAlertController(
//          title: "Action not allowed",
//          message: "Tapping on links is not allowed. Sorry!",
//          preferredStyle: .Alert)
//        
//        alertController.addAction(UIAlertAction(
//          title: "OK", style: .Default, handler: nil))
//        
//        presentViewController(alertController,
//          animated: true, completion: nil)
//        
//        return
//        
//      }
//      
//      decisionHandler(.Allow)
//    
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    /* Create our preferences on how the web page should be loaded */
//    let preferences = WKPreferences()
//    preferences.javaScriptEnabled = false
//    
//    /* Create a configuration for our preferences */
//    let configuration = WKWebViewConfiguration()
//    configuration.preferences = preferences
//    
//    /* Now instantiate the web view */
//    webView = WKWebView(frame: view.bounds, configuration: configuration)
//    
//    if let theWebView = webView{
//      /* Load a web page into our web view */
//      let url = NSURL(string: "http://www.apple.com")
//      let urlRequest = NSURLRequest(URL: url!)
//      theWebView.loadRequest(urlRequest)
//      theWebView.navigationDelegate = self
//      view.addSubview(theWebView)
//      
//    }
//    
//  }
//  
//}

/* 2 */
import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  var webView: WKWebView?
  
  /* Start the network activity indicator when the web view is loading */
  func webView(webView: WKWebView!,
    didStartProvisionalNavigation navigation: WKNavigation!){
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  /* Stop the network activity indicator when the loading finishes */
  func webView(webView: WKWebView!,
    didFinishNavigation navigation: WKNavigation!){
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  func webView(webView: WKWebView!,
    decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse!,
    decisionHandler: ((WKNavigationResponsePolicy) -> Void)!){
    
      println(navigationResponse.response.MIMEType)
      
      decisionHandler(.Allow)
      
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Create our preferences on how the web page should be loaded */
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = false
    
    /* Create a configuration for our preferences */
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    
    /* Now instantiate the web view */
    webView = WKWebView(frame: view.bounds, configuration: configuration)
    
    if let theWebView = webView{
      /* Load a web page into our web view */
      let url = NSURL(string: "http://www.apple.com")
      let urlRequest = NSURLRequest(URL: url!)
      theWebView.loadRequest(urlRequest)
      theWebView.navigationDelegate = self
      view.addSubview(theWebView)
      
    }
    
  }
  
}

