//
//  ViewController.swift
//  Recording Audio
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

class ViewController: UIViewController,
AVAudioPlayerDelegate, AVAudioRecorderDelegate {
  
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer?
  
func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
  /* The audio session is deactivated here */
}

func audioPlayerEndInterruption(player: AVAudioPlayer!,
  withOptions flags: Int) {
    if flags == AVAudioSessionInterruptionFlags_ShouldResume{
      player.play()
    }
}
  
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer!,
    successfully flag: Bool){
      
      if flag{
        println("Audio player stopped correctly")
      } else {
        println("Audio player did not stop correctly")
      }
      
      audioPlayer = nil
      
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
    successfully flag: Bool){
      
      if flag{
        
        println("Successfully stopped the audio recording process")
        
        /* Let's try to retrieve the data for the recorded file */
        var playbackError:NSError?
        var readingError:NSError?
        
        let fileData = NSData(contentsOfURL: audioRecordingPath(),
          options: .MappedRead,
          error: &readingError)
        
        /* Form an audio player and make it play the recorded data */
        audioPlayer = AVAudioPlayer(data: fileData, error: &playbackError)
        
        /* Could we instantiate the audio player? */
        if let player = audioPlayer{
          player.delegate = self
          
          /* Prepare to play and start playing */
          if player.prepareToPlay() && player.play(){
            println("Started playing the recorded audio")
          } else {
            println("Could not play the audio")
          }
          
        } else {
          println("Failed to create an audio player")
        }
        
      } else {
        println("Stopping the audio recording failed")
      }
      
      /* Here we don't need the audio recorder anymore */
      self.audioRecorder = nil;
      
  }
  
  
  func audioRecordingPath() -> NSURL{
    
    let fileManager = NSFileManager()
    
    let documentsFolderUrl = fileManager.URLForDirectory(.DocumentDirectory,
      inDomain: .UserDomainMask,
      appropriateForURL: nil,
      create: false,
      error: nil)
    
    return documentsFolderUrl!.URLByAppendingPathComponent("Recording.m4a")
    
  }
  
  func audioRecordingSettings() -> [NSObject : AnyObject]{
    
    /* Let's prepare the audio recorder options in the dictionary.
    Later we will use this dictionary to instantiate an audio
    recorder of type AVAudioRecorder */
    
    return [
      AVFormatIDKey : kAudioFormatMPEG4AAC as NSNumber,
      AVSampleRateKey : 16000.0 as NSNumber,
      AVNumberOfChannelsKey : 1 as NSNumber,
      AVEncoderAudioQualityKey : AVAudioQuality.Low.rawValue as NSNumber
    ]
    
  }
  
  func startRecordingAudio(){
    
    var error: NSError?
    
    let audioRecordingURL = self.audioRecordingPath()
    
    audioRecorder = AVAudioRecorder(URL: audioRecordingURL,
      settings: audioRecordingSettings(),
      error: &error)
    
    if let recorder = audioRecorder{
      
      recorder.delegate = self
      /* Prepare the recorder and then start the recording */
      
      if recorder.prepareToRecord() && recorder.record(){
        
        println("Successfully started to record.")
        
        /* After 5 seconds, let's stop the recording process */
        let delayInSeconds = 5.0
        let delayInNanoSeconds =
        dispatch_time(DISPATCH_TIME_NOW,
          Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), {
          [weak self] in
          self!.audioRecorder!.stop()
          })
        
      } else {
        println("Failed to record.")
        audioRecorder = nil
      }
      
    } else {
      println("Failed to create an instance of the audio recorder")
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Ask for permission to see if we can record audio */
    
    var error: NSError?
    let session = AVAudioSession.sharedInstance()
    
    if session.setCategory(AVAudioSessionCategoryPlayAndRecord,
      withOptions: .DuckOthers,
      error: &error){
        
        if session.setActive(true, error: nil){
          println("Successfully activated the audio session")
          
          session.requestRecordPermission{[weak self](allowed: Bool) in
            
            if allowed{
              self!.startRecordingAudio()
            } else {
              println("We don't have permission to record audio");
            }
            
          }
        } else {
          println("Could not activate the audio session")
        }
        
    } else {
      
      if let theError = error{
        println("An error occurred in setting the audio " +
          "session category. Error = \(theError)")
      }
      
    }
  }
  
  
}

