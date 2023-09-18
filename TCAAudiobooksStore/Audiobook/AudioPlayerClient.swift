//
//  AudioPlayerClient.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 18.09.2023.
//

import Foundation
import ComposableArchitecture

private enum AudioPlayerClientKey: DependencyKey {
    static let liveValue = AudioPlayerService(chapters: ViewModel.chapters)
}

extension DependencyValues {
  var audioPlayerClient: AudioPlayerService {
    get { self[AudioPlayerClientKey.self] }
    set { self[AudioPlayerClientKey.self] = newValue }
  }
}
