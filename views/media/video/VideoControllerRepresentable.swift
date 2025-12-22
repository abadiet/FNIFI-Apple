import SwiftUI
import VLCKit


final class ControllerHolder {
    var controller: VideoController?
}

#if os(macOS)
struct VideoControllerRepresentable: NSViewControllerRepresentable {
    class Coordinator: VideoControllerDelegate {
        var parent: VideoControllerRepresentable

        init(parent: VideoControllerRepresentable) {
            self.parent = parent
        }

        func play() {
            parent.holder.controller?.player.play()
        }

        func pause() {
            parent.holder.controller?.player.pause()
        }
        
        func jump(progress: Double) {
            parent.holder.controller?.player.position = progress
        }
        
        func getRemainingTime() -> VLCTime? {
            return parent.holder.controller?.player.remainingTime
        }

        func getVideoSize() -> CGSize? {
            return parent.holder.controller?.player.videoSize
        }
    }

    let url: URL
    private let holder = ControllerHolder()

    func makeNSViewController(context: Context) -> VideoController {
        let controller = VideoController(url: url)
        controller.delegate = context.coordinator
        self.holder.controller = controller
        return controller
    }

    func updateNSViewController(_ nsViewController: VideoController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
#endif

#if os(iOS)
struct VideoControllerRepresentable: UIViewControllerRepresentable {
    class Coordinator: VideoControllerDelegate {
        var parent: VideoControllerRepresentable

        init(parent: VideoControllerRepresentable) {
            self.parent = parent
        }

        func play() {
            parent.holder.controller?.player.play()
        }

        func pause() {
            parent.holder.controller?.player.pause()
        }
        
        func jump(progress: Double) {
            parent.holder.controller?.player.position = progress
        }
        
        func getRemainingTime() -> VLCTime? {
            return parent.holder.controller?.player.remainingTime
        }
        
        func getVideoSize() -> CGSize? {
            return parent.holder.controller?.player.videoSize
        }
    }

    let url: URL
    private let holder = ControllerHolder()

    func makeUIViewController(context: Context) -> VideoController {
        let controller = VideoController(url: url)
        controller.delegate = context.coordinator
        self.holder.controller = controller
        return controller
    }

    func updateUIViewController(_ nsViewController: VideoController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
#endif
