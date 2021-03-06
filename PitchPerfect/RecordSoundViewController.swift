//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Tu Tong on 6/3/15.
//  Copyright (c) 2015 Tu Tong. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    // retain audio recorder
    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // recorded audio
    var recordedAudio: RecordAudio!
    
    /////////////////////////
    // Recording state
    /////////////////////////
    
    var isRecording: Bool = false {
        didSet {
            stopButton.hidden = !isRecording
            recordButton.enabled = !isRecording
            recordLabel.text = isRecording ? "Recording in progress" : "Tap to record"
        }
    }
    
    /////////////////////////
    // Overrided funcs
    /////////////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isRecording = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "playSound") {
            let psvc: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            psvc.recordedAudio = recordedAudio
        }
    }

    /////////////////////////
    // <AVAudioRecorderDelegate>
    /////////////////////////
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordAudio(filePathURL: recorder.url)
            performSegueWithIdentifier("playSound", sender: self)
        }
        else {
            println("Recording was not successfully")
            var alert = UIAlertView(title: "Recorder is stopped",
                message: "Recording was not successfully",
                delegate: nil,
                cancelButtonTitle: nil)
            alert.show()
        }
        
        isRecording = false
    }
    
    /////////////////////////
    // Action methods
    /////////////////////////
    
    @IBAction func recordAction(sender: AnyObject) {
        // Recording in progress
        isRecording = true
        
        // get document dir path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        
        // Default record name
        let pathArray = [dirPath, "recordedVoice.wav"]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // shared audio session play and record voice
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // create an AVAudioRecorder instance and start recored sound
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopAction(sender: AnyObject) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    
    
    
    
    
    
    
    
    
}

