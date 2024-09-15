//
//  AudioManager.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-15.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    var audioPlayer: AVAudioPlayer?
    
    func playAmbientMusic(named fileName: String, withExtension fileExtension: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Failed to locate audio file.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Infinite loop
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
}

