//
//  AppDelegate.swift
//  Playing Audio in the Background
//
//  Created by Vandad Nahavandipoor on 7/7/14.
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
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {
  
  var window: UIWindow?
  var audioPlayer: AVAudioPlayer?
  
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      
      let dispatchQueue =
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      
      dispatch_async(dispatchQueue, {[weak self] in
        
        let audioSession = AVAudioSession.sharedInstance()
        NSNotificationCenter.defaultCenter().addObserver(self!,
          selector: "handleInterruption:",
          name: AVAudioSessionInterruptionNotification,
          object: nil)
        
        do {
          try audioSession.setActive(true)
        } catch _ {
        }
        
        do {
          try audioSession.setCategory(AVAudioSessionCategoryPlayback)
          print("Successfully set the audio session")
        } catch let error as NSError {
          print("Could not set the audio session \(error)")
        } catch {
          fatalError()
        }
        
        let filePath = NSBundle.mainBundle().pathForResource("MySong",
          ofType:"mp3")
        
        let fileData: NSData?
        do {
          fileData = try NSData(contentsOfFile: filePath!,
            options: .DataReadingMappedIfSafe)
        } catch _ {
          fileData = nil
        }
        
        do {
          /* Start the audio player */
          self!.audioPlayer = try AVAudioPlayer(data: fileData!)
        } catch let error as NSError {
          self!.audioPlayer = nil
          print("Error = \(error)")
        } catch {
          fatalError()
        }
        
        /* Did we get an instance of AVAudioPlayer? */
        if let theAudioPlayer = self!.audioPlayer{
          theAudioPlayer.delegate = self
          if theAudioPlayer.prepareToPlay() &&
            theAudioPlayer.play(){
              print("Successfully started playing")
          } else {
            print("Failed to play")
          }
        } else {
          /* Handle the failure of instantiating the audio player */
        }
        })
      
      return true
  }
  
  func handleInterruption(notification: NSNotification){
    /* Audio Session is interrupted. The player will be paused here */
    
    let interruptionTypeAsObject =
    notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
    
    let interruptionType = AVAudioSessionInterruptionType(rawValue:
      interruptionTypeAsObject.unsignedLongValue)
    
    if let type = interruptionType{
      if type == .Ended{
        
        /* resume the audio if needed */
        
      }
    }
    
  }
  
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
    successfully flag: Bool){
      
      print("Finished playing the song")
      
      /* The flag parameter tells us if the playback was successfully
      finished or not */
      if player == audioPlayer{
        audioPlayer = nil
      }
      
  }
  
}

