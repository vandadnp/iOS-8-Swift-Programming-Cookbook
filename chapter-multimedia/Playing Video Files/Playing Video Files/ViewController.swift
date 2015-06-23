//
//  ViewController.swift
//  Playing Video Files
//
//  Created by Vandad Nahavandipoor on 7/10/14.
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
import MediaPlayer

class ViewController: UIViewController {
  
  var moviePlayer: MPMoviePlayerController?
  var playButton: UIButton?
  
  func videoHasFinishedPlaying(notification: NSNotification){
    
    print("Video finished playing")
    
    /* Find out what the reason was for the player to stop */
    let reason =
    notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
      as! NSNumber?
    
    if let theReason = reason{
      
      let reasonValue = MPMovieFinishReason(rawValue: theReason.integerValue)
      
      switch reasonValue!{
      case .PlaybackEnded:
        /* The movie ended normally */
        print("Playback Ended")
      case .PlaybackError:
        /* An error happened and the movie ended */
        print("Error happened")
      case .UserExited:
        /* The user exited the player */
        print("User exited")
      }
      
      print("Finish Reason = \(theReason)")
      stopPlayingVideo()
    }
    
  }
  
  func stopPlayingVideo() {
    
    if let player = moviePlayer{
      NSNotificationCenter.defaultCenter().removeObserver(self)
      player.stop()
      player.view.removeFromSuperview()
    }
    
  }
  
  func startPlayingVideo(){
    
    /* First let's construct the URL of the file in our application bundle
    that needs to get played by the movie player */
    let mainBundle = NSBundle.mainBundle()
    
    let url = mainBundle.URLForResource("Sample", withExtension: "m4v")
    
    /* If we have already created a movie player before,
    let's try to stop it */
    if let _ = moviePlayer{
      stopPlayingVideo()
    }
    
    /* Now create a new movie player using the URL */
    moviePlayer = MPMoviePlayerController(contentURL: url)
    
    if let player = moviePlayer{
      
      /* Listen for the notification that the movie player sends us
      whenever it finishes playing */
      NSNotificationCenter.defaultCenter().addObserver(self,
        selector: "videoHasFinishedPlaying:",
        name: MPMoviePlayerPlaybackDidFinishNotification,
        object: nil)
      
      print("Successfully instantiated the movie player")
      
      /* Scale the movie player to fit the aspect ratio */
      player.scalingMode = .AspectFit
      
      view.addSubview(player.view)
      
      player.setFullscreen(true, animated: false)
      
      /* Let's start playing the video in full screen mode */
      player.play()
      
    } else {
      print("Failed to instantiate the movie player")
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playButton = UIButton(type: .System)
    
    if let button = playButton{
      
      /* Add our button to the screen. Pressing this button
      will start the video playback */
      button.frame = CGRect(x: 0, y: 0, width: 70, height: 37)
      button.center = view.center
      
      button.autoresizingMask =
        [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]
      
      button.addTarget(self,
        action: "startPlayingVideo",
        forControlEvents: .TouchUpInside)
      
      button.setTitle("Play", forState: .Normal)
      
      view.addSubview(button)
      
    }
    
  }
  
}

