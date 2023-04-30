//
//  AKSounder.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import AVFoundation
import AudioToolbox

class AKSounder: NSObject, AVAudioPlayerDelegate {
    
    private var mAudioPlayer: AVAudioPlayer?
    var repeatSoundInfinitively: Bool = false
    var isSpeakerOn: Bool = true
    
    override init() {
        super.init()
    }
    
    private func playSound(_ name: String) {
        if mAudioPlayer != nil { mAudioPlayer?.play(); return }
        guard
            let soundFile = Bundle.main.path(forResource: name, ofType: ".mp3")
            else {
                return
        }
        let url = URL(fileURLWithPath: soundFile)
        mAudioPlayer = try? AVAudioPlayer(contentsOf: url)
        mAudioPlayer?.delegate = self
        mAudioPlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if repeatSoundInfinitively { player.play() }
    }
    
    func music(name: String) { playSound(name) }
    func play() { mAudioPlayer?.play() }
    func pause() { mAudioPlayer?.pause() }
    func stop() { mAudioPlayer?.stop() }
    
}
