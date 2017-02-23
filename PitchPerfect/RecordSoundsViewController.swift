//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by i221 on 17/02/17.
//  Copyright © 2017 com.udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var filePath: URL!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordingButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "mimimi.wav"
        let pathArray = [dirPath, recordingName]
        filePath = URL(string: pathArray.joined(separator: "/"))
        
        //print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(_ sender: Any) {
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to record"
        
        audioRecorder.stop()
        
        try! audioPlayer = AVAudioPlayer(contentsOf: filePath!)
        print( audioPlayer.duration)
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print(audioRecorder.url)
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) // redirect to other view
        }else{
            print("Recording was not successfully")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController // GET VIEW CONTROLLER
            let recordedAudioURL = sender as! URL // GET URL
            playSoundsVC.recordedAudioURL = recordedAudioURL //SET URL TO VARIABLE IN playSoundsViewController
            playSoundsVC.recordTime =  "\(audioPlayer.duration)"
        }
    }
}

