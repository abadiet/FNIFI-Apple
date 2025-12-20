import SwiftUI
import FNIFIModule


struct ImageView: View {
    let file: File
    @Binding var isDetailedViewActive: Bool
    @State private var url: URL? = nil
    @State private var showStatus: Bool = false

    var body: some View {
        NavigationLink(destination: DetailedImageView(file: file, previewUrl: url, isActive: $isDetailedViewActive)) {
            if let url {
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
            self.url = URL(fileURLWithPath: self.file.getLocalPreviewPath())
        }
    }
}
