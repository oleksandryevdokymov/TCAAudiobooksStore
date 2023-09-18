//
//  StoreClient.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 18.09.2023.
//

import Foundation
import ComposableArchitecture

private enum StoreServiceClientKey: DependencyKey {
    static let liveValue = StoreService()
}

extension DependencyValues {
  var storeService: StoreService {
    get { self[StoreServiceClientKey.self] }
    set { self[StoreServiceClientKey.self] = newValue }
  }
}
