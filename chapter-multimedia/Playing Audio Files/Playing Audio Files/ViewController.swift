//
//  ViewController.swift
//  Playing Audio Files
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
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
  
  var audioPlayer: AVAudioPlayer?
  
  /* The delegate message that will let us know that the player
  has finished playing an audio file */
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
    successfully flag: Bool) {
      print("Finished playing the song")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dispatchQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    dispatch_async(dispatchQueue, {
      let mainBundle = NSBundle.mainBundle()
      
      /* Find the location of our file to feed to the audio player */
      let filePath = mainBundle.pathForResource("MySong", ofType:"mp3")
      
      if let path = filePath{
        let fileData = NSData(contentsOfFile: path)
        
        do {
          /* Start the audio player */
          self.audioPlayer = try AVAudioPlayer(data: fileData!)
          
          guard let player = self.audioPlayer else{
            return
          }
          
          /* Set the delegate and start playing */
          player.delegate = self
          if player.prepareToPlay() && player.play(){
            /* Successfully started playing */
          } else {
            /* Failed to play */
          }
          
        } catch{
          self.audioPlayer = nil
          return
        }
        
      }
      
    })
    
  }
  
}

