import SwiftUI

#if os(macOS)
struct GifView: View {
    let url: URL
    @State private var image: Image?
    
    var body: some View {
        Group {
            if let image {
                MovableImageView(image: image)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            CGAnimateImageAtURLWithBlock(url as CFURL, nil) { index, cgImage, stop in
                self.image = Image(nsImage: .init(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height)))
            }
        }

    }
}
#endif
