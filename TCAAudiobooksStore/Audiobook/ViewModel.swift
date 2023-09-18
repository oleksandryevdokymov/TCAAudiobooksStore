//
//  ViewModel.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 18.09.2023.
//

import Foundation
import Combine

final class ViewModel {
    static var chapters: [Chapter] = [
        Chapter(name: "Chapter 01"),
        Chapter(name: "Chapter 02"),
        Chapter(name: "Chapter 03"),
        Chapter(name: "Chapter 04"),
        Chapter(name: "Chapter 05"),
    ]
}


struct Chapter: Identifiable, Equatable {
    var id = UUID()
    let name: String
    let ext: String = "mp3"
}

