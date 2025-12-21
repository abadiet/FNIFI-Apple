import SwiftUI
import FNIFIModule


struct GridView: View {
    @Binding var files: [File]
    @State private var zoom: CGFloat = 3.0
    @State private var nColumns: Int = 5
    private var nPlaceHolders: Int {
        let nLastRow = (files.count % nColumns)
        if nLastRow > 0 {
            return nColumns - nLastRow
        }
        return 0
    }
    @State private var isDetailedViewActive = false
    @State private var position = ScrollPosition(idType: File.ID.self)
    @State var lastId: File.ID? = nil
    let minZoom: CGFloat = 1.0
    let maxZoom: CGFloat = 5.0
    let nColumnsMaxZoom: Int = 20
    let radius: CGFloat = 1.5
    let spacing: CGFloat = 1.5
    
    var body: some View {
        GeometryReader { geo in
            if files.isEmpty {
                Image(systemName: "photo.stack")
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .font(.largeTitle)
            } else {
                let size = abs(geo.size.width - (CGFloat(nColumns - 1) * spacing)) / CGFloat(nColumns)  /* abs to avoid a warning */
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: spacing), count: nColumns), spacing: spacing) {
                        ForEach(0..<nPlaceHolders, id: \.self) { _ in
                            Color.clear
                                .frame(width: size, height: size)
                        }
                        ForEach(files) { file in
                            PreviewView(file: file, width: size, height: size, isDetailedViewActive: $isDetailedViewActive)
                                .cornerRadius(radius)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition($position)
                .onChange(of: isDetailedViewActive) {
                    if !isDetailedViewActive {
                        if let lastId {
                            position.scrollTo(id: lastId)
                        }
                    } else {
                        lastId = position.viewID(type: File.ID.self)
                    }
                }
                .onAppear {
                    position.scrollTo(edge: .bottom)
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
            nColumns = nColumnsMaxZoom
        } else {
            nColumns = 2 * (Int(maxZoom) - Int(ceil(zoom))) + 1
        }
    }
}
