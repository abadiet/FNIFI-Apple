import SwiftUI

#if os(macOS)
struct GIFView: View {
    let url: URL
    @State private var image: Image?
    
    var body: some View {
        Group {
            if let image {
                MovableView {
                    image
                        .resizable()
                }
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

#if os(iOS)
struct GIFView: View {
    let url: URL
    @State private var image: Image?
    
    var body: some View {
        Group {
            if let image {
                MovableView {
                    image
                        .resizable()
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            CGAnimateImageAtURLWithBlock(url as CFURL, nil) { index, cgImage, stop in
                self.image = Image(uiImage: .init(cgImage: cgImage))
            }
        }

    }
}
#endif
