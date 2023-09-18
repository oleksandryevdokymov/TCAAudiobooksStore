//
//  UnlockView.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 18.09.2023.
//

import SwiftUI

public struct UnlockView: View {
    public var startLearningAction: () -> Void

    public init(startLearningAction: @escaping () -> Void) {
        self.startLearningAction = startLearningAction
    }

    public var body: some View {
        GeometryReader { geo in
            Group {
                ZStack {
                    VStack(spacing: 14) {
                        Text("Unlock learning")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .background(Color.clear)
                        
                        Text("Grow on the go by listening and reading the world's best ideas")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.black)
                            .background(Color.clear)
                            .padding([.leading, .trailing], 20)
                        
                        Button(action: startLearningAction, label: {
                            Text("Start Listening • $89,99")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(CTAButtonStyle(color: .mainBlueColor, minHeight: 60))
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height / 2)
                .background(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .mainColor, location: 0),
                            .init(color: .clear, location: 1),
                            
                        ]),
                            startPoint:  UnitPoint(x: 0.5, y: 0.17),
                            endPoint: .top)
                )
     
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        
        .ignoresSafeArea()
    }
}


public struct ProgressAlert_Previews: PreviewProvider {
    static public var previews: some View {
        UnlockView(startLearningAction: {
            print("")
        })
    }
}
