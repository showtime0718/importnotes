//
//  RecordHelp.swift
//  MyNotes
//
//  Created by 陳宥瑜 on 2017/7/19.
//  Copyright © 2017年 li. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioSessionMode{
    case record
    case play
}

class RecordHelp:NSObject,AVAudioRecorderDelegate{
    
    var audioRecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var isRecording = false
    
    func settingAudioSession(mode:AudioSessionMode){
        let session = AVAudioSession.sharedInstance()
        do{
            switch mode {
            case .record:
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            case .play:
                try session.setCategory(AVAudioSessionCategoryPlayback)
                try session.setActive(false)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func recordAudio() {
        settingAudioSession(mode: .record)
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
        isRecording = true
    }
    
    func stopRecord() {
        audioRecorder?.stop()
        isRecording = false
        settingAudioSession(mode: .play)
    }
    
    func playRecordedSound() {
        if isRecording == false{
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0.0
            audioPlayer?.play()
        }
    }
    
    func stopPlay() {
        if isRecording == false{
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0.0
        }
    }
    
    override init() {
        //init an audio recorder
        super.init()
        let filename = "User.wav"
        let path = NSHomeDirectory() + "/Documents" + filename
        let url = URL(fileURLWithPath: path)
        let recordSettings:[String:Any] = [
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        do{
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSettings)
            audioRecorder?.delegate = self
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true{
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
            }catch{
            }
        }
    }
}
