//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohamed El-Alfy on 2/27/15.
//  Copyright (c) 2015 Mohamed El-Alfy. All rights reserved.
//

import UIKit
import AVFoundation


let segueID = "StopRecording"

class RecordSoundsViewController: UIViewController {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func record(sender: UIButton) {
        self.recordingInProgress.hidden = false
        self.stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        var pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath!)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled =  true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        self.recordingInProgress.hidden = true
        self.audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.recordingInProgress.hidden = true
        self.stopButton.hidden = true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueID {
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let data  = sender as! RecordedAudio
            playSoundVC.recordedAudio = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            self.recordedAudio = RecordedAudio()
            self.recordedAudio.recordingFilePath = recorder.url
            self.recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier(segueID, sender: recordedAudio)
        }else{
            println("Recording Audio was not Successfully")
            self.recordButton.enabled = true
            self.stopButton.hidden = true
        }
        
    }
}

