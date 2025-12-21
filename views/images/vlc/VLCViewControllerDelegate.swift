import VLCKit


protocol VLCViewControllerDelegate: AnyObject {
    func play()
    func pause()
    func jump(progress: Double)
    func getRemainingTime() -> VLCTime?
}
