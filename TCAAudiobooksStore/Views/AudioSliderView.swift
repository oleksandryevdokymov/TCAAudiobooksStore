//
//  AudioSliderView.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 17.09.2023.
//

import SwiftUI

struct AudioSliderView: View {
    var value: Binding<Double>
    var range: ClosedRange<Double>
    var minValue: String
    var maxValue: String
    
    init(value: Binding<Double>,
         in range: ClosedRange<Double>,
         minValue: String,
         maxValue: String) {
        self.value = value
        self.range = range
        self.minValue = minValue
        self.maxValue = maxValue
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            Slider(value: value, in: range) {
                Text("Track Slider")
            } minimumValueLabel: {
                Text(minValue)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondaryTextColor)
                    .frame(minWidth: 40)
            } maximumValueLabel: {
                Text(maxValue)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondaryTextColor)
                    .frame(minWidth: 40)
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onEnded { value in
                    let percent = min(max(0, Double(value.location.x / geometry.size.width * 1)), 1)
                    let newValue = range.lowerBound + round(percent * (range.upperBound - range.lowerBound))
                    
                    self.value.wrappedValue = newValue
                })
        }
    }
}
