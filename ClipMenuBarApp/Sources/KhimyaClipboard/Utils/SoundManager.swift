import Foundation
import AVFoundation
import AppKit

@MainActor
class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        setupCopySound()
    }
    
    private func setupCopySound() {
        // Generate a simple beep sound programmatically
        let sampleRate: Double = 44100
        let duration: Double = 0.1 // 100ms
        let frequency: Double = 800 // Hz
        
        let frameCount = Int(sampleRate * duration)
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(frameCount)) else {
            return
        }
        
        audioBuffer.frameLength = AVAudioFrameCount(frameCount)
        
        // Generate sine wave
        if let channelData = audioBuffer.floatChannelData?[0] {
            for i in 0..<frameCount {
                let sample = sin(2.0 * Double.pi * frequency * Double(i) / sampleRate)
                channelData[i] = Float(sample * 0.3) // Reduce volume to 30%
            }
        }
        
        // Convert buffer to data
        do {
            let audioFile = try AVAudioFile(forWriting: URL(fileURLWithPath: NSTemporaryDirectory() + "copy_sound.wav"), 
                                          settings: audioFormat.settings)
            try audioFile.write(from: audioBuffer)
            
            // Load the generated sound
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile.url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Could not create copy sound: \(error)")
        }
    }
    
    func playCopySound() {
        if let player = audioPlayer {
            player.currentTime = 0
            player.play()
        } else {
            // Fallback to system beep
            NSSound.beep()
        }
    }
} 