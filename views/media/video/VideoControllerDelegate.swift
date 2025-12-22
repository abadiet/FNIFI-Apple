import VLCKit


protocol VideoControllerDelegate: AnyObject {
    func play()
    func pause()
    func jump(progress: Double)
    func getRemainingTime() -> VLCTime?
    func getVideoSize() -> CGSize?
}
