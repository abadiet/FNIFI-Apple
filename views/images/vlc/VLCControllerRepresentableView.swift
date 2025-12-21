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


struct VLCControllerRepresentableView: NSViewControllerRepresentable {
    let url: URL

    func makeNSViewController(context: Context) -> VLCViewController {
        return VLCViewController(url: url)
    }

    func updateNSViewController(_ nsViewController: VLCViewController, context: Context) {
    }
}
