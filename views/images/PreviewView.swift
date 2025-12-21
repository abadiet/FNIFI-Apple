import SwiftUI
import FNIFIModule


struct PreviewView: View {
    let file: File
    let width: CGFloat
    let height: CGFloat
    @Binding var isDetailedViewActive: Bool
    @State private var url: URL? = nil
    @State private var showStatus: Bool = false

    var body: some View {
        Group {
            if let url {
                NavigationLink(destination: DetailedView(file: file, previewUrl: url, isActive: $isDetailedViewActive)) {
                    AsyncImage(url: url){ image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "questionmark")
                    }
                    .frame(width: width, height: height)
                    .clipped()
                }
                .buttonStyle(.borderless)
            } else {
                ProgressView()
                    .frame(width: width, height: height)
            }
        }
        .task {
            self.url = URL(fileURLWithPath: self.file.getLocalPreviewPath())
        }
    }
}
