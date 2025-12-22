import Foundation
import VLCKit
internal import Combine


class VideoModel: ObservableObject {
    @Published var frameWidth: CGFloat = 0
    @Published var frameHeight: CGFloat = 0
    @Published var isPlaying: Bool = true
    @Published var position: Double = 0.0
    @Published var duration: VLCTime?
    private var timerDuration: Timer?
    private var timerVideoSize: Timer?
    let controller: VideoControllerRepresentable
    let coordinator: VideoControllerRepresentable.Coordinator
    var windowSize: CGSize?
    private var previousWindowSize: CGSize?
    private var aspectRatio: CGFloat?

    init(url: URL) {
        self.controller = VideoControllerRepresentable(url: url)
        self.coordinator = self.controller.makeCoordinator()
        
        self.timerDuration = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let time = self.coordinator.getRemainingTime()
            if let time = time, time.value != nil {
                self.duration = VLCTime(int: -1 * time.intValue)
                timer.invalidate()
            }
        }
        
        self.timerVideoSize = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let aspectRatio {
                if let windowSize {
                    if let previousWindowSize {
                        if windowSize != previousWindowSize {
                            /* windowSize has changed */
                            if aspectRatio > 1 {
                                frameWidth = windowSize.width
                                frameHeight = Double(windowSize.width) / aspectRatio
                            } else {
                                frameWidth = Double(windowSize.height) * aspectRatio
                                frameHeight = windowSize.height
                            }
                            self.previousWindowSize = windowSize
                        }
                    }
                }
            } else {
                /* videoSize has not been retrieve yet */
                let videoSize = self.coordinator.getVideoSize()
                if let videoSize {
                    if videoSize != CGSize(width: 0, height: 0) {
                        if let windowSize {
                            aspectRatio = Double(videoSize.width) / Double(videoSize.height)
                            if let aspectRatio {
                                if aspectRatio > 1 {
                                    frameWidth = windowSize.width
                                    frameHeight = Double(windowSize.width) / aspectRatio
                                } else {
                                    frameWidth = Double(windowSize.height) * aspectRatio
                                    frameHeight = windowSize.height
                                }
                                previousWindowSize = windowSize
                            }
                        }
                    }
                }
            }
        }
    }

    deinit {
        self.timerDuration?.invalidate()
        self.timerVideoSize?.invalidate()
    }
}
