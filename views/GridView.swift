import SwiftUI
import FNIFIModule

struct GridView: View {
    @Binding var files: [UnsafePointer<fnifi.file.File>]
    @State private var zoom: CGFloat = 3.0
    @State private var NColumns: Int = 5
    let minZoom: CGFloat = 1.0
    let maxZoom: CGFloat = 5.0
    let NColumnsMaxZoom: Int = 20
    let radius: CGFloat = 3.0
    let spacing: CGFloat = 3.0
    
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
        .gesture(
            MagnifyGesture()
                .onChanged({ value in
                    updateZoom(value)
                })
        )
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button(action: { zoomOut() }) {
                    Image(systemName: "minus")
                }
                .help("Zoom Out")
                .keyboardShortcut("-", modifiers: .command)
                Button(action: { zoomIn() }) {
                    Image(systemName: "plus")
                }
                .help("Zoom In")
                .keyboardShortcut("+", modifiers: .command)
            }
        }
        .toolbarBackgroundVisibility(.hidden, for: .automatic)
        .navigationTitle("")
        .onAppear {
            updateColumns()
        }
    }
    
    private func zoomIn() {
        withAnimation {
            zoom = min(zoom + 1.0, maxZoom)
            updateColumns()
        }
    }

    private func zoomOut() {
        withAnimation {
            zoom = max(zoom - 1.0, minZoom)
            updateColumns()
        }
    }

    private func updateZoom(_ value: MagnifyGesture.Value) {
        withAnimation {
            zoom = max(min(zoom * pow(value.magnification, 0.1), maxZoom), minZoom)
            updateColumns()
        }
    }

    private func updateColumns() {
        if (zoom <= 1.0) {
            NColumns = NColumnsMaxZoom
        } else {
            NColumns = 2 * (Int(maxZoom) - Int(ceil(zoom))) + 1
        }
    }
}
