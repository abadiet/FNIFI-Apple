import SwiftUI
import FNIFIModule

struct GridView: View {
    let files: [UnsafePointer<fnifi.file.File>]
    let NColumns: Int
    let spacing: CGFloat
    let radius: CGFloat = 3.0
    
    var body: some View {
        GeometryReader { geometry in
            let size = (geometry.size.width - (CGFloat(NColumns - 1) * spacing)) / CGFloat(NColumns)
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.fixed(size), spacing: spacing), count: NColumns), spacing: spacing) {
                    ForEach(files, id: \.self) { file in
                        AsyncImageView(file: file)
                            .frame(width: size, height: size)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: radius))
                    }
                }
            }
        }
    }
}
