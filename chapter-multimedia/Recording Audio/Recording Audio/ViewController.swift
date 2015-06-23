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
  
  func audioPlayerBeginInterruption(player: AVAudioPlayer) {
    /* The audio session is deactivated here */
  }
  
  func audioPlayerEndInterruption(player: AVAudioPlayer,
    withOptions flags: Int) {
      if flags == AVAudioSessionInterruptionFlags_ShouldResume{
        player.play()
      }
  }
  
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
    successfully flag: Bool){
      
      if flag{
        print("Audio player stopped correctly")
      } else {
        print("Audio player did not stop correctly")
      }
      
      audioPlayer = nil
      
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
    successfully flag: Bool){
      
      if flag{
        
        print("Successfully stopped the audio recording process")
        
        do{
          let fileData = try NSData(contentsOfURL: audioRecordingPath(),
            options: .MappedRead)
          
          audioPlayer = try AVAudioPlayer(data: fileData)
          
          guard let player = audioPlayer else{
            return
          }
          
          player.delegate = self
          
          /* Prepare to play and start playing */
          if player.prepareToPlay() && player.play(){
            print("Started playing the recorded audio")
          } else {
            print("Could not play the audio")
          }
        } catch let error as NSError{
          print("Error = \(error)")
          audioPlayer = nil
        }
        
      } else {
        print("Stopping the audio recording failed")
      }
      
      /* Here we don't need the audio recorder anymore */
      self.audioRecorder = nil;
      
  }
  
  
  func audioRecordingPath() -> NSURL{
    
    let fileManager = NSFileManager()
    
    let documentsFolderUrl: NSURL?
    do {
      documentsFolderUrl = try fileManager.URLForDirectory(.DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: false)
    } catch _ {
      documentsFolderUrl = nil
    }
    
    return documentsFolderUrl!.URLByAppendingPathComponent("Recording.m4a")
    
  }
  
  func audioRecordingSettings() -> [String : AnyObject]{
    
    /* Let's prepare the audio recorder options in the dictionary.
    Later we will use this dictionary to instantiate an audio
    recorder of type AVAudioRecorder */
    
    return [
      AVFormatIDKey : NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
      AVSampleRateKey : 16000.0 as NSNumber,
      AVNumberOfChannelsKey : 1 as NSNumber,
      AVEncoderAudioQualityKey : AVAudioQuality.Low.rawValue as NSNumber
    ]
    
  }
  
  func startRecordingAudio(){
    
    let audioRecordingURL = self.audioRecordingPath()
    
    do {
      audioRecorder = try AVAudioRecorder(URL: audioRecordingURL,
        settings: audioRecordingSettings())
      
      guard let recorder = audioRecorder else{
        return
      }
      
      recorder.delegate = self
      /* Prepare the recorder and then start the recording */
      
      if recorder.prepareToRecord() && recorder.record(){
        
        print("Successfully started to record.")
        
        /* After 5 seconds, let's stop the recording process */
        let delayInSeconds = 5.0
        let delayInNanoSeconds =
        dispatch_time(DISPATCH_TIME_NOW,
          Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), {
          self.audioRecorder!.stop()
          })
        
      } else {
        print("Failed to record.")
        audioRecorder = nil
      }
      
    } catch {
      audioRecorder = nil
    }
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Ask for permission to see if we can record audio */
    
    let session = AVAudioSession.sharedInstance()
    
    do {
      try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
            withOptions: .DuckOthers)
      do {
        try session.setActive(true)
        print("Successfully activated the audio session")
        
        session.requestRecordPermission{allowed in
          
          if allowed{
            self.startRecordingAudio()
          } else {
            print("We don't have permission to record audio");
          }
          
        }
      } catch {
        print("Could not activate the audio session")
      }
        
    } catch let error as NSError {
        print("An error occurred in setting the audio " +
          "session category. Error = \(error)")
    }
  }
  
  
}

