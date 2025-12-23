import SwiftUI
import FNIFIModule
import WebKit


struct DetailedView: View {
    @Binding var selectedFile: File?
    @State private var previewUrl: URL? = nil
    @State private var url: URL? = nil

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.windowBackground)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { selectedFile = nil }
            
            if let selectedFile {
                if let url {
                    let kind = selectedFile.getKind()
                    switch kind {
                    case .BMP, .JPEG2000, .JPEG, .PNG, .WEBP, .AVIF, .PBM, .PGM, .PPM, .PXM, .PFM, .SR, .RAS, .TIFF, .EXR, .HDR, .PIC:
                        AsyncImage(url: url){ image in
                            MovableView {
                                image
                                    .resizable()
                            }
                        } placeholder: {
                            ZStack {
                                if let previewUrl {
                                    AsyncImage(url: previewUrl) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                    }
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
                            if let previewUrl {
                                AsyncImage(url: previewUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                }
                            }
                            Image(systemName: "questionmark")
                        }
                    }
                } else {
                    ZStack {
                        if let previewUrl {
                            AsyncImage(url: previewUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                            }
                        }
                        ProgressView()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation, content: {
                Button(action: { selectedFile = nil }, label: {
                    Image(systemName: "chevron.backward")
                })
            })
        }
        .task {
            if let selectedFile {
                self.previewUrl = URL(fileURLWithPath: selectedFile.getLocalPreviewPath())
                self.url = URL(fileURLWithPath: selectedFile.getLocalCopyPath())
            }
        }
    }
}
