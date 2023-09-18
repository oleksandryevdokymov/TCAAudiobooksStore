//
//  SpeedButtonStyle.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 17.09.2023.
//

import SwiftUI

public struct CTAButtonStyle: ButtonStyle {
    private let color: Color
    private let minHeight: CGFloat
    public init(color: Color = .speedBackgroundColor, minHeight: CGFloat = 32) {
        self.color = color
        self.minHeight = minHeight
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minHeight: minHeight)
            .foregroundColor(.white)
            .background(color.clipShape(RoundedRectangle(cornerRadius: 6)))
    }
}
