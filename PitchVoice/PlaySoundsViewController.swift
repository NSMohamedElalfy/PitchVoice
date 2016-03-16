//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohamed El-Alfy on 4/19/15.
//  Copyright (c) 2015 Mohamed El-Alfy. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var recordedAudio:RecordedAudio!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /*if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
        var filePathURL = NSURL.fileURLWithPath(filePath)
        self.audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL, error: nil)
        self.audioPlayer.enableRate = true
        }else{
        println("the filePath is empty")
        }*/
        do{
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.recordingFilePath)
            self.audioPlayer.enableRate = true
            self.audioEngine = AVAudioEngine()
            try self.audioFile = AVAudioFile(forReading: recordedAudio.recordingFilePath)
        }catch{
            
        }
        
    }
    
    
    @IBAction func saveOutput(sender:UIButton) {
        
    }
    
    
    @IBAction func playSlowly(sender: UIButton) {
        self.playAudio(false)
    }
    
    @IBAction func playFast(sender: UIButton) {
        
        self.playAudio(true)
    }
    
    @IBAction func stopPlayingSound(sender: UIButton) {
        self.audioPlayer.stop()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        self.playAudioWithVarialbePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        self.playAudioWithVarialbePitch(-1000)
    }
    func playAudio(fast:Bool){
        self.audioPlayer.stop()
        self.audioPlayer.rate = fast ? 2.5:0.5
        self.audioPlayer.currentTime = 0.0
        self.audioPlayer.play()
    }
    
    func playAudioWithVarialbePitch(pitch:Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        //changePitchEffect.rate = 0.5
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: audioFile.processingFormat)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        
        do{
            
            try audioEngine.start()
            audioPlayerNode.play()
            
            let dirPath = NSTemporaryDirectory()
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = "\(formatter.stringFromDate(currentDateTime)).wav"
            let pathArray = [dirPath,recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            print(filePath!)
            let audioFile = try! AVAudioFile(forWriting: filePath!, settings: audioEngine.mainMixerNode.outputFormatForBus(0).settings)
            audioEngine.inputNode!.installTapOnBus(0, bufferSize: 4096, format: audioEngine.inputNode!.outputFormatForBus(0), block: { (buffer:AVAudioPCMBuffer, when:AVAudioTime) -> Void in
                do{
                    try audioFile.writeFromBuffer(buffer)
                }catch{
                    print("error")
                }
            })
            
            
        }catch{
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
