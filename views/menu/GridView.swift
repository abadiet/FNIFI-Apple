import SwiftUI
import FNIFIModule


struct GridView: View {
    @Binding var files: [File]
    @State private var selectedFile: File?
    @State private var zoom: CGFloat = 3.0
    @State private var lastZoom: CGFloat = 3.0
    @State private var nColumns: Int = 5
    private var nPlaceHolders: Int {
        let nLastRow = (files.count % nColumns)
        if nLastRow > 0 {
            return nColumns - nLastRow
        }
        return 0
    }
    @State private var position = ScrollPosition(idType: File.ID.self)
    let minZoom: CGFloat = 1.0
    let maxZoom: CGFloat = 5.0
    let nColumnsMaxZoom: Int = 20
    let radius: CGFloat = 2.5
    let spacing: CGFloat = 1.5
    
    var body: some View {
        GeometryReader { geo in
            if files.isEmpty {
                Image(systemName: "photo.stack")
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .font(.largeTitle)
            } else {
                ZStack {
                    let size = abs(geo.size.width - (CGFloat(nColumns - 1) * spacing)) / CGFloat(nColumns)  /* abs to avoid a warning */
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: spacing), count: nColumns), spacing: spacing) {
                            ForEach(0..<nPlaceHolders, id: \.self) { _ in
                                Color.clear
                                    .frame(width: size, height: size)
                            }
                            ForEach(files) { file in
                                PreviewView(file: file, width: size, height: size, selectedFile: $selectedFile)
                                    .cornerRadius(radius)
                            }
                        }
                    }
                    .scrollPosition($position)
                    .onAppear {
                        position.scrollTo(edge: .bottom)
                    }
                    
                    if selectedFile != nil {
                        DetailedView(selectedFile: $selectedFile)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
        .gesture(
            MagnifyGesture()
                .onChanged({ value in
                    zoom = value.magnification * lastZoom
                    if zoom < minZoom {
                        zoom = minZoom
                    }
                    if zoom > maxZoom {
                        zoom = maxZoom
                    }
                    updateColumns()
                })
                .onEnded({ _ in
                    lastZoom = zoom
                })
        )
        .toolbar {
            if selectedFile == nil {
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
        }
        .toolbarBackgroundVisibility(.hidden, for: .automatic)
        .navigationTitle("")
        .onAppear {
            updateColumns()
        }
    }
    
    private func zoomIn() {
        zoom = min(zoom + 1.0, maxZoom)
        updateColumns()
    }

    private func zoomOut() {
        zoom = max(zoom - 1.0, minZoom)
        updateColumns()
    }

    private func updateZoom(_ value: MagnifyGesture.Value) {
        zoom = max(min(zoom * pow(value.magnification, 0.1), maxZoom), minZoom)
        updateColumns()
    }

    private func updateColumns() {
        withAnimation {
            if (zoom <= 1.0) {
                nColumns = nColumnsMaxZoom
            } else {
#if os(macOS)
                nColumns = 2 * (Int(maxZoom) - Int(ceil(zoom))) + 5  /* at least 5 files */
#endif
                
#if os(iOS)
                nColumns = 2 * (Int(maxZoom) - Int(ceil(zoom))) + 1  /* at least 1 file */
#endif
            }
        }
    }
}
