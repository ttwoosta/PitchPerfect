//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Tu Tong on 6/3/15.
//  Copyright (c) 2015 Tu Tong. All rights reserved.
//

import UIKit
import AVFoundation

var audioRecorder:AVAudioRecorder!

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var recordedAudio: RecordAudio!
    
    var isRecording: Bool = false {
        didSet {
            
            self.stopButton.hidden = !isRecording
            self.recordButton.enabled = !isRecording
            self.recordLabel.text = isRecording ? "Recording in progress" : "Tap to record"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("\(self) viewDidLoad")
        self.isRecording = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "playSound") {
            let psvc: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            psvc.recordedAudio = self.recordedAudio
        }
    }

    @IBAction func recordAction(sender: AnyObject) {
        if (self.isRecording) {
            return
        }
        self.isRecording = true
        
        // get document dir path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        
        // sound file's path formatted as date-time of record
        //let currentDateTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss"
        //let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
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
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordAudio(filePathURL: recorder.url)
            self.performSegueWithIdentifier("playSound", sender: self)
        }
        else {
            println("Recording was not successfully")
        }
        
        self.isRecording = false
    }
    
    
    @IBAction func stopAction(sender: AnyObject) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

