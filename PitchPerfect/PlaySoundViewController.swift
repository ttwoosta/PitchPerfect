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

    
    @IBOutlet weak var slowButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var recordedAudio: RecordAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("\(self) viewDidLoad")
        
        //let URL = NSBundle.mainBundle().URLForResource("movie_quote.mp3", withExtension: nil);
        assert(self.recordedAudio != nil, "Mp3 file cannot be found")
        
        var error: NSError?
        self.audioPlayer = AVAudioPlayer(contentsOfURL: self.recordedAudio.filePathURL, error: &error)
        assert(error == nil, "Error occurs: \(error)")
        self.audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathURL, error: nil)
    }
    
    func audioEngineReset() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        self.audioPlayer.currentTime = 0
    }
    
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
    
    @IBAction func stopAction(sender: AnyObject) {
        
        self.audioPlayer.stop()
        
    }

    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
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
    
    
    @IBAction func popVC(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("\(self) viewWillAppear")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(self) viewDidAppear")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("\(self) viewWillDisappear")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("\(self) viewDidDisappear")
    }
}