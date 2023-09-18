//
//  AudiobookPlayerView.swift
//  TCAAudiobooksStore
//
//  Created by Oleksandr Yevdokymov on 17.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct AudiobookPlayerView: View {
    
    let store: StoreOf<AudiobookFeature>
    
    @State var value: Double = 0.0
    
    @State var segmentIndex: Int = 0
    
    let segmentOptions = ["headphones", "list.dash"]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            mainView
            
                .customPopup(isShow: !viewStore.isPurchased) {
                    UnlockView(startLearningAction: {
                        viewStore.send(.buy)
                    })
                }
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }
    
    @ViewBuilder @MainActor
    private var mainView: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .center, spacing: 10) {
                
                Image("TheTimeMachine" )
                    .resizable ()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding([.trailing, .leading], 80)
                    .padding(.top, 60)
                
                Text("\(viewStore.currentChapter.name) OF \(viewStore.chapters.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondaryTextColor)
                    .lineLimit(1)
                
                Text("Design is not how a thing looks, but how it works")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .padding([.leading, .trailing], 50)
                    .multilineTextAlignment(.center)
                
                AudioSliderView(value:  Binding(
                    get: { viewStore.currentTime },
                    set: { value in
                        store.send(.sliderValueChanged(value))
                    }),
                                in: 0...viewStore.maxDuration,
                                minValue: viewStore.formattedCurrentTime,
                                maxValue: viewStore.formattedMaxDuration)
                .tint(.mainBlueColor)
                .padding([.leading, .trailing], 20)

                
                Button(action: {
                    viewStore.send(.speedAction)
                }, label: {
                    Text("Speed x\(String(format: "%.1f", viewStore.speed))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .padding([.leading, .trailing], 14)
                })
                .buttonStyle(CTAButtonStyle())
                .padding(.bottom, 30)
                
                buttonsView()
                    .padding(.bottom, 30)
                
                RoundedSegmentedControlView(preselectedIndex: $segmentIndex,
                                            options: segmentOptions,
                                            color: .mainBlueColor)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .background(Color.mainColor)
        }
        
    }
    
    @ViewBuilder
    private func buttonsView() -> some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 32) {
                Button {
                    viewStore.send(.perevious)
                } label: {
                    Image(systemName: "backward.end.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .fontWeight(.thin)
                        .foregroundColor(.black)
                }
                
                Button {
                    viewStore.send(.goBackward)
                } label: {
                    Image(systemName: "gobackward.5")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                
                Button {
                    viewStore.send(.playPause)
                } label: {
                    Image(systemName: viewStore.isPlaying
                          ? "pause.fill"
                          : "play.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                }
                
                Button {
                    viewStore.send(.goForward)
                } label: {
                    Image(systemName: "goforward.10")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                
                Button {
                    viewStore.send(.next)
                } label: {
                    Image(systemName: "forward.end.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .fontWeight(.thin)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
        AudiobookPlayerView(store: Store(initialState: AudiobookFeature.State()) {
            AudiobookFeature()
        })
    }
}

