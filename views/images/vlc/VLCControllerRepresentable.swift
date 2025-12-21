/*import SwiftUI
import AVKit


struct VideoView: View {
    let fnifiUrl: URL
    let kind: File.Kind
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            if let player {
                VideoPlayer(player: player)
            } else {
                ProgressView()
            }
        }
        .task {
            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension(File.extention(kind: kind))
            do {
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                try FileManager.default.copyItem(at: fnifiUrl, to: url)
            } catch {
                
            }
            player = AVPlayer(url: url)
            player?.play()
        }
    }
}*/

import SwiftUI
import VLCKit


final class ControllerHolder {
    var controller: VLCViewController?
}

struct VLCControllerRepresentable: NSViewControllerRepresentable {
    class Coordinator: VLCViewControllerDelegate {
        var parent: VLCControllerRepresentable

        init(parent: VLCControllerRepresentable) {
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
    }

    let url: URL
    private let holder = ControllerHolder()

    func makeNSViewController(context: Context) -> VLCViewController {
        let controller = VLCViewController(url: url)
        controller.delegate = context.coordinator
        self.holder.controller = controller
        return controller
    }

    func updateNSViewController(_ nsViewController: VLCViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
