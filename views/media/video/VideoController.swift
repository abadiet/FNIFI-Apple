import VLCKit
import SwiftUI


#if os(macOS)
class VideoController: NSViewController {
    let url: URL
    var player: VLCMediaPlayer!
    weak var delegate: VideoControllerDelegate?
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        player = VLCMediaPlayer()
        player.media = VLCMedia(url: url)
        player.drawable = self.view
        player.play()
    }

    deinit {
        player.stop()
    }
}
#endif

#if os(iOS)
class VideoController: UIViewController {
    let url: URL
    var player: VLCMediaPlayer!
    weak var delegate: VideoControllerDelegate?

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        player = VLCMediaPlayer()
        player.media = VLCMedia(url: url)
        player.drawable = self.view
        player.play()
    }

    deinit {
        player.stop()
    }
}
#endif

