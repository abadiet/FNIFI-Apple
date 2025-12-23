import SwiftUI
import FNIFIModule
import WebKit


struct DetailedView: View {
    let file: File
    let previewUrl: URL
    @Binding var isActive: Bool
    @State private var url: URL? = nil

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
                    GIFView(url: url)
                case .MKV, .AVI, .MTS, .MOV, .WMV, .YUV, .MP4, .M4V:
                    VideoView(url: url)
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
    }
}
