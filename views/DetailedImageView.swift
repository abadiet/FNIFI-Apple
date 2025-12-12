import SwiftUI
import FNIFIModule


struct DetailedImageView: View {
    let file: File
    let previewUrl: URL?
    @Binding var isActive: Bool
    @State private var url: URL? = nil

    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url){ image in
                    MovableImageView(image: image)
                } placeholder: {
                    ZStack {
                        if let prevUrl = previewUrl {
                            AsyncImage(url: prevUrl) { image in
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
                    if let prevUrl = previewUrl {
                        AsyncImage(url: prevUrl) { image in
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
        .toolbarBackgroundVisibility(.hidden, for: .automatic)
        .navigationTitle("")
        .task {
            await loadImage()
        }
        .onAppear {
            isActive = true
        }
        .onDisappear() {
            isActive = false
        }
    }

    private func loadImage() async {
        await Task.detached(priority: .background) {
            let theUrl = await URL(fileURLWithPath: String(self.file.getLocalCopyPath()))
            await MainActor.run {
                url = theUrl
            }
        }.value
    }
}
