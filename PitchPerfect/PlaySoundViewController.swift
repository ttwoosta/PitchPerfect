//
//  ViewControllerB.swift
//  PitchPerfect
//
//  Created by Tu Tong on 6/3/15.
//  Copyright (c) 2015 Tu Tong. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var recordedAudio: RecordAudio!
    var audioFile: AVAudioFile!
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    
    /////////////////////////
    // Overrided funcs
    /////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let URL = NSBundle.mainBundle().URLForResource("movie_quote.mp3", withExtension: nil);
        assert(self.recordedAudio != nil, "Mp3 file cannot be found")
        
        var error: NSError?
        self.audioPlayer = AVAudioPlayer(contentsOfURL: self.recordedAudio.filePathURL, error: &error)
        assert(error == nil, "Error occurs: \(error)")
        self.audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathURL, error: nil)
    }
    
    /////////////////////////
    // Shared funcs
    /////////////////////////
    
    func audioEngineReset() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        self.audioPlayer.currentTime = 0
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioEngineReset()
        
        // create an instance of AVAudioPlayerNode
        // then attach to audio engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create an instance of AVAudioUnitTimePitch
        // change pitch effect to high value of 1000
        // attach to engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect audioPlayerNode -> changePitchEffect -> output speaker
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // schedule file playback at beginning
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // start audio engine
        audioEngine.startAndReturnError(nil)
        
        // play audio
        audioPlayerNode.play()
    }

    /////////////////////////
    // Action methods
    /////////////////////////
    
    @IBAction func slowAction(sender: AnyObject) {
        audioEngineReset()
        
        self.audioPlayer.rate = 0.5
        self.audioPlayer.play()
    }
    
    @IBAction func fastAction(sender: AnyObject) {
        audioEngineReset()
        
        self.audioPlayer.rate = 2.0
        self.audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAction(sender: AnyObject) {
        self.audioPlayer.stop()
    }

    
}