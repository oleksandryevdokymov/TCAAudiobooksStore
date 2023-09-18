//
//  RoundedSegmentedControlView.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 17.09.2023.
//

import SwiftUI

struct RoundedSegmentedControlView: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    let color: Color
    let circleSize: CGFloat = 60
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Rectangle()
                        .fill(color)
                        .cornerRadius(circleSize)
                        .padding(2)
                        .opacity(preselectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    preselectedIndex = index
                                }
                            }
                }
                .overlay(
                    Image(systemName: options[index])
                        .resizable()
                        .frame(width: 20, height: 20)
                        .fontWeight(.regular)
                        .foregroundColor(preselectedIndex == index ? .white : .black)
                )
            }
        }
        
        .frame(width: circleSize * CGFloat(options.count), height: circleSize)
        .cornerRadius(circleSize)
        .overlay(
            RoundedRectangle(cornerRadius: circleSize)
                .stroke(Color.segmentedBorderColor, lineWidth: 1)
        )
    }
}

struct RoundedSegmentedControlView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(0) { RoundedSegmentedControlView(preselectedIndex: $0, options: ["headphones", "list.dash"], color: .mainBlueColor) }
    }
}


