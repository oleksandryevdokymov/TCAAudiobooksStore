//
//  CustomPopupViewModifier.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 18.09.2023.
//

import SwiftUI

/// Could be used with any View that we tend to use like Popup and Alert style views
public struct CustomPopupViewModifier<Popup: View>: ViewModifier {
    public var isShow: Bool
    @ViewBuilder public let popup: Popup

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isShow {
                popup
            }
        }
    }
}

public extension View {
    func customPopup<Popup: View>(isShow: Bool, @ViewBuilder popup: () -> Popup) -> some View {
        modifier(CustomPopupViewModifier(isShow: isShow, popup: popup))
    }
}
