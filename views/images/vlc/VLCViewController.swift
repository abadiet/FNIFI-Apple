import VLCKit


class VLCViewController: NSViewController {
    let url: URL
    private var player: VLCMediaPlayer!
    
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
    
    @IBAction func playButtonClicked(_ sender: NSButton) {
        player.play()
    }

    @IBAction func pauseButtonClicked(_ sender: NSButton) {
        player.pause()
    }

    @IBAction func stopButtonClicked(_ sender: NSButton) {
        player.stop()
    }
    
    deinit {
        player.stop()
    }
}
