import SwiftUI
import FNIFIModule


struct PreviewView: View {
    let file: File
    let width: CGFloat
    let height: CGFloat
    @Binding var selectedFile: File?
    @State private var url: URL? = nil

    var body: some View {
        Group {
            if let url {
                Button(action: { selectedFile = file }) {
                    AsyncImage(url: url){ image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .clipped()
                    } placeholder: {
                        Image(systemName: "questionmark")
                            .frame(width: width, height: height)
                    }
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
