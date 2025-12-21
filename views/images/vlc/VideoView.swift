import SwiftUI
import VLCKit


struct VideoView: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat
    @State private var isPlaying: Bool = true
    @State private var position: Double = 0.0
    private var duration: VLCTime?
    
    private let controller: VLCControllerRepresentable?
    private var coordinator: VLCControllerRepresentable.Coordinator?
    
    init(url: URL, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
        self.controller = VLCControllerRepresentable(url: url)
        self.coordinator = controller?.makeCoordinator()
        self.duration = coordinator?.getRemainingTime()
    }

    var body: some View {
        controller
            .frame(width: width, height: height, alignment: .center)
            .clipped()
            .toolbar {
                ToolbarItem(placement: .status) {
                    if isPlaying {
                        Button(action: {
                            coordinator?.pause()
                            isPlaying = false
                        }) {
                            Image(systemName: "pause.fill")
                        }
                    } else {
                        Button(action: {
                            coordinator?.play()
                            isPlaying = true
                        }) {
                            Image(systemName: "play.fill")
                        }
                    }
                    
                    if let duration = self.duration {
                        ProgressBarView(duration: Double(truncating: duration.value ?? 0) / 1000.0, isActive: $isPlaying, onManualChange: { progress in
                            coordinator?.jump(progress: progress)
                        })
                        .frame(width: 200, height: 4)
                    }
                }
            }
    }
}
