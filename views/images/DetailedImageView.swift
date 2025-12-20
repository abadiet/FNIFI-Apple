import SwiftUI
import FNIFIModule
import WebKit


struct DetailedImageView: View {
    let file: File
    let previewUrl: URL?
    @Binding var isActive: Bool
    @State private var url: URL? = nil

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url){ image in
                    MovableImageView(image: image)
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
        .task {
            self.url = URL(fileURLWithPath: String(self.file.getLocalCopyPath()))
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
