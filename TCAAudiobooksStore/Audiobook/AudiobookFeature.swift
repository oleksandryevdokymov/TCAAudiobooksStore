//
//  AudiobookFeature.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 18.09.2023.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct AudiobookFeature: Reducer {
    @Dependency(\.audioPlayerClient) var audioPlayerClient
    @Dependency(\.continuousClock) var clock
    @Dependency(\.storeService) var storeService
     
    struct State: Equatable {
        var isPurchased: Bool = false
        
        var chapters: [Chapter] = ViewModel.chapters
        var currentChapter: Chapter = ViewModel.chapters[0]
        var speed: Float = 1.0
        
        var isPlaying: Bool = false
        var currentTime: Double = 0.0
        var maxDuration: Double = 0.0
        
        var formattedCurrentTime: String = "00:00"
        var formattedMaxDuration: String = "--:--"
    }
    
    enum Action: Equatable {
        case onAppear
        case timerUpdated
        // Player actions
        case playPause
        case perevious
        case next
        case goBackward
        case goForward
        case speedAction
        case sliderValueChanged(Double)
        
        case buy
        case purchased
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .onAppear:
            state.isPurchased = storeService.isPurchased
            state.isPlaying = audioPlayerClient.isPlaying
            return .run { send in
                for await _ in self.clock.timer(interval: .milliseconds(500)) {
                  await send(.timerUpdated)
                }
            }
        case .playPause:
            audioPlayerClient.isPlaying ? audioPlayerClient.pause() : audioPlayerClient.play()
            state.isPlaying = audioPlayerClient.isPlaying
            return .none
        case .perevious:
            audioPlayerClient.previous()
            return .none
        case .next:
            audioPlayerClient.next()
            return .none
        case .goBackward:
            audioPlayerClient.goBackward()
            return .none
        case .goForward:
            audioPlayerClient.goForward()
            return .none
        case .speedAction:
            audioPlayerClient.changeSpeed()
            return .none
        case .sliderValueChanged(let value):
            audioPlayerClient.setTime(from: value)
            return .none
        case .timerUpdated:
            audioPlayerClient.updateDurations()
            state.currentTime = audioPlayerClient.currentTime
            state.maxDuration = audioPlayerClient.maxDuration
            state.formattedCurrentTime = audioPlayerClient.formattedCurrentTime
            state.formattedMaxDuration = audioPlayerClient.formattedMaxDuration
            state.isPlaying = audioPlayerClient.isPlaying
            state.currentChapter = audioPlayerClient.currentChapter
            state.speed = audioPlayerClient.speed
            return .none
            // Store Service
        case .buy:
            return .run { send in
                do {
                    let _ = try await storeService.purchase()
                    await send(.purchased)
                } catch StoreError.failedVerification {
                    print("Your purchase could not be verified by the App Store.")
                } catch {
                    print("Failed purchase for: \(error)")
                }
            }
        case .purchased:
            state.isPurchased = storeService.isPurchased
            return .none
        }
    }
}
