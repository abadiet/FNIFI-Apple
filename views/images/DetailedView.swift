import SwiftUI
import FNIFIModule
import WebKit


struct DetailedView: View {
    let file: File
    let previewUrl: URL
    @Binding var isActive: Bool
    @State private var url: URL? = nil
    @State private var aspectRatio: CGFloat = 0

    var body: some View {
        Group {
            if let url {
                let kind = file.getKind()
                switch kind {
                case .BMP, .JPEG2000, .JPEG, .PNG, .WEBP, .AVIF, .PBM, .PGM, .PPM, .PXM, .PFM, .SR, .RAS, .TIFF, .EXR, .HDR, .PIC:
                    AsyncImage(url: url){ image in
                        MovableView {
                            image
                                .resizable()
                        }
                    } placeholder: {
                        ZStack {
                            AsyncImage(url: previewUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                            }
                            Image(systemName: "questionmark")
                        }
                    }
                case .GIF:
                    GifView(url: url)
                case .MKV, .AVI, .MTS, .MOV, .WMV, .YUV, .MP4, .M4V:
                    GeometryReader { geo in
                        MovableView {
                            if aspectRatio > 1 {
                                VideoView(url: url, width: geo.size.width, height: geo.size.width / aspectRatio)
                            } else {
                                VideoView(url: url, width: aspectRatio * geo.size.height, height: geo.size.height)
                            }
                        }
                    }
                case .UNKNOWN:
                    ZStack {
                        AsyncImage(url: previewUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                        }
                        Image(systemName: "questionmark")
                    }
                }
            } else {
                ZStack {
                    AsyncImage(url: previewUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            aspectRatio = geo.size.width / geo.size.height
                                        }
                                }
                            )
                    } placeholder: {
                    }
                    ProgressView()
                }
            }
        }
        .task {
            self.url = URL(fileURLWithPath: self.file.getLocalCopyPath())
        }
        .onAppear {
            isActive = true
        }
        .onDisappear() {
            isActive = false
        }
        .toolbarBackgroundVisibility(.hidden, for: .automatic)
        .navigationTitle("")
    }
}
