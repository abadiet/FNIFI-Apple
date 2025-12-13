import SwiftUI
import FNIFIModule


struct ImageView: View {
    let file: File
    @Binding var isDetailedViewActive: Bool
    @State private var url: URL? = nil
    @State private var showStatus: Bool = false

    var body: some View {
        NavigationLink(destination: DetailedImageView(file: file, previewUrl: url, isActive: $isDetailedViewActive)) {
            if let url = url {
                AsyncImage(url: url){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "questionmark")
                }
            } else {
                ProgressView()
            }
        }
        .buttonStyle(.borderless)
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        await Task.detached(priority: .background) {
            let theUrl = await URL(fileURLWithPath: String(self.file.getLocalPreviewPath()))
            await MainActor.run {
                url = theUrl
            }
        }.value
    }
}
