//
//  AudioPlayerService.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 18.09.2023.
//

import AVKit
import SwiftUI
import MediaPlayer
import ComposableArchitecture

protocol AudioPlayerServiceProtocol: ObservableObject {
    var currentTime: Double { get set }
    var maxDuration: Double { get set }
    var formattedCurrentTime: String { get set }
    var formattedMaxDuration: String { get set }
    var isPlaying: Bool { get }
    
    func play()
    func pause()
    func goBackward()
    func goForward()
    func setTime(from value: Double)
    func updateDurations()
    
    func previous()
    func next()
    func changeSpeed()
}

final class AudioPlayerService: NSObject, AudioPlayerServiceProtocol, AVAudioPlayerDelegate {
    
    // MARK: - Public Properties
    var index = 0
    var speed: Float = 1.0
    var currentChapter: Chapter
    @Published var currentTime: Double = 0.0 {
        didSet {
            formattedCurrentTime = dateComponentsFormatter.string(from: TimeInterval(currentTime)) ?? "00:00"
        }
    }
    @Published var maxDuration: Double = 0.0 {
        didSet {
            formattedMaxDuration = dateComponentsFormatter.string(from: TimeInterval(maxDuration)) ?? "--:--"
        }
    }
    
    @Published var formattedCurrentTime: String = "--:--"
    @Published var formattedMaxDuration: String = "00:00"
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    // MARK: - Private properties
    private var audioPlayer: AVAudioPlayer?
    private let chapters: [Chapter]
    private let speeds: [Float] = [1.0, 2.0, 0.5]
    private var speedIndex = 0
    
    
    
    // MARK: - Initialization and Life cycle
    init(chapters: [Chapter]) {
        self.chapters = chapters
        self.currentChapter = chapters[0]
        super.init()
        setupAudioSession()
        setupAudioPlayerForChapter(with: currentChapter.name, with: currentChapter.ext)
        updateDurations()
        setupNowPlaying()
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Public Interface
    func play() {
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func changeSpeed() {
        let currentTime = currentTime
        setupAudioPlayerForChapter(with: currentChapter.name, with: currentChapter.ext)
        audioPlayer?.currentTime = currentTime
        speedIndex = (speedIndex + 1) < speeds.count ? speedIndex + 1 : 0
        
        speed = speeds[speedIndex]
        
        audioPlayer?.enableRate = true
        audioPlayer?.prepareToPlay()
        audioPlayer?.rate = speeds[speedIndex]
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    }
    
    func previous() {
        guard chapters.count > 1 else { return }
        index = (index - 1) >= 0 ? index - 1 : chapters.count - 1
        currentChapter = chapters[index]
        setupAudioPlayerForChapter(with: currentChapter.name, with: currentChapter.ext)
        audioPlayer?.play()
    }
    
    func next() {
        guard chapters.count > 1 else { return }
        index = (index + 1) < chapters.count ? index + 1 : 0
        currentChapter = chapters[index]
        setupAudioPlayerForChapter(with: currentChapter.name, with: currentChapter.ext)
        audioPlayer?.play()
    }
    
    func setTime(from value: Double) {
        guard let time = TimeInterval(exactly: value) else {
            return
        }
        
        audioPlayer?.currentTime = time
    }
    
    func goForward() {
        guard let audioPlayer else {
            return
        }
        
        let newTime = audioPlayer.currentTime + 10
        audioPlayer.currentTime = newTime < audioPlayer.duration ? newTime : maxDuration
    }
    
    func goBackward() {
        guard let audioPlayer else {
            return
        }
        
        let newTime = audioPlayer.currentTime - 5
        audioPlayer.currentTime = newTime < 0.0 ? 0.0 : newTime
    }
    
    func updateDurations() {
        guard let audioPlayer else {
            return
        }
        
        self.maxDuration = audioPlayer.duration
        self.currentTime = audioPlayer.currentTime
    }


    
    // MARK: - Private implementation
    private func stop() {
        audioPlayer?.stop()
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setActive(true)
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupNowPlaying() {
        var nowPlayingInfo: [String : Any] = [:]
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentChapter.name
        
        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = maxDuration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer?.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupAudioPlayerForChapter(with fileName: String, with ext: String? = nil) {
        audioPlayer = nil
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            print("Failed to find \(fileName) in bundle.")
            
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to load \(fileName) from bundle.")
        }
    }
    
    private let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
}
