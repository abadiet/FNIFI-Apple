import SwiftUI


struct VideoView: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VLCControllerRepresentableView(url: url)
            .frame(width: width, height: height, alignment: .center)
            .clipped()
    }
}
