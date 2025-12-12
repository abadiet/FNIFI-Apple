import SwiftUI
import FNIFIModule


struct DetailedImageView: View {
    let file: UnsafePointer<fnifi.file.File>
    let previewUrl: URL?
    @State private var url: URL? = nil
    @State private var showStatus = false

    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url){ image in
                    image
                        .resizable()
                        .scaledToFit()
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
                        if showStatus {
                            Image(systemName: "questionmark")
                        }
                    }
                    .task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        showStatus = true
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
                    if showStatus {
                        ProgressView()
                    }
                }
                .task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    showStatus = true
                }
            }
        }
        .toolbarBackgroundVisibility(.hidden, for: .automatic)
        .navigationTitle("")
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        await Task.detached(priority: .background) {
            let theUrl = await URL(fileURLWithPath: String(self.file.pointee.getLocalCopyPath()))
            await MainActor.run {
                showStatus = false
                url = theUrl
            }
        }.value
    }
}
