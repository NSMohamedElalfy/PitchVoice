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
        
        
        /*
        // Recording settings
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        
        [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
        [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
*/
        
        //let dirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let dirPath = NSTemporaryDirectory()
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = "\(formatter.stringFromDate(currentDateTime)).wav"
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath!)
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        }catch{
            
        }
        
        

        audioRecorder.delegate = self
        audioRecorder.meteringEnabled =  true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        self.recordingInProgress.hidden = true
        self.audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setActive(false)
        }catch{
            
        }

        
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
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.recordedAudio = RecordedAudio()
            self.recordedAudio.recordingFilePath = recorder.url
            self.recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier(segueID, sender: recordedAudio)
        }else{
            print("Recording Audio was not Successfully")
            self.recordButton.enabled = true
            self.stopButton.hidden = true
        }
        
    }
}

