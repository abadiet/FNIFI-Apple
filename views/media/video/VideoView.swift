import SwiftUI
import VLCKit


#if os(macOS)
let ratioProgressBar = 0.3
#endif

#if os(iOS)
let ratioProgressBar = 0.6
#endif

struct VideoView: View {
    @StateObject private var model: VideoModel
    
    init(url: URL) {
        self._model = StateObject(wrappedValue: VideoModel(url: url))
    }
    
    var body: some View {
        GeometryReader { geo in
            MovableView {
                model.controller
                    .frame(width: model.frameWidth, height: model.frameHeight, alignment: .center)
                    .clipped()
                    .toolbar {
                        ToolbarItem(placement: .status) {
                            if model.isPlaying {
                                Button(action: {
                                    model.coordinator.pause()
                                    model.isPlaying = false
                                }) {
                                    Image(systemName: "pause.fill")
                                }
                            } else {
                                Button(action: {
                                    model.coordinator.play()
                                    model.isPlaying = true
                                }) {
                                    Image(systemName: "play.fill")
                                }
                            }
                        }
                        ToolbarItem(placement: .status) {
                            if let duration = model.duration {
                                ProgressBarView(
                                    duration: Double(truncating: duration.value ?? 0) / 1000.0,
                                    isActive: $model.isPlaying,
                                    activate: {
                                        model.coordinator.play()
                                    },
                                    deActivate: {
                                        model.coordinator.pause()
                                    },
                                    onManualChange: { progress in
                                        model.coordinator.jump(progress: progress)
                                    },
                                    onFinished: {
                                        model.coordinator.pause()
                                        model.coordinator.jump(progress: 0)
                                    }
                                )
                                .frame(width: geo.size.width * ratioProgressBar, height: 4)
                                .padding([.trailing])
                            }
                        }
                    }
                    

                Color.clear  /* hack for blocking mouse events from the controller */
                    .contentShape(Rectangle())
                    .onTapGesture {}
            }
            .onAppear {
                model.windowSize = geo.size
            }
            .onChange(of: geo.size) {
                model.windowSize = geo.size
            }
        }
    }
}
