//
//  TCAAudiobooksStoreApp.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 17.09.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAAudiobooksStoreApp: App {
    var body: some Scene {
        WindowGroup {
            AudiobookPlayerView(store: Store(initialState: AudiobookFeature.State()) {
                AudiobookFeature()
            })
        }
    }
}
