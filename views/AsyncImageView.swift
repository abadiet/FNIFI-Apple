import SwiftUI
import FNIFIModule


struct AsyncImageView: View {
    let file: UnsafePointer<fnifi.file.File>
    @State private var url: URL? = nil

    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url){ result in
                    result.image?
                        .resizable()
                        .scaledToFill()
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        await Task.detached(priority: .background) {
            let theUrl = await URL(fileURLWithPath: String(self.file.pointee.getLocalPreviewPath()))
            await MainActor.run {
                url = theUrl
            }
        }.value
    }
}
