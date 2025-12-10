import SwiftUI
import FNIFIModule

struct ContentView: View {
    @StateObject private var fi = FNIFIWrapper()
    @State var fiStoring: UnsafeMutablePointer<fnifi.connection.IConnection>?
    @State var navPath = NavigationPath()

    @State private var zoom: CGFloat = 3.0
    let minZoom: CGFloat = 1.0
    let maxZoom: CGFloat = 5.0
    let NColumnsMaxZoom: Int = 20
    @State private var NColumns: Int = 5

    let spacing: CGFloat = 3.0
    
    private enum SelectedView {
        case collections, sort, filter, grid
    }
    @State private var selectedView: SelectedView? = .grid

    var body: some View {
        if (fi.isSetup) {
            NavigationSplitView {
                List(selection: $selectedView) {
                    NavigationLink("Grid", value: SelectedView.grid)
                    NavigationLink("Collections", value: SelectedView.collections)
                    NavigationLink("Sort", value: SelectedView.sort)
                    NavigationLink("Filter", value: SelectedView.filter)
                }
            } detail: {
                NavigationStack {
                    switch selectedView {
                    case .collections:
                        NewCollectionView(fi: fi)
                    case .sort:
                        Text("Sort View")
                            .navigationTitle("Sort")
                    case .filter:
                        Text("Filter View")
                            .navigationTitle("Filter")
                    case .grid:
                        GridView(
                            files: fi.files,
                            NColumns: NColumns,
                            spacing: spacing,
                        )
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
                    case .none:
                        Text("Select an option")
                    }
                }
            }
            .onAppear(
                perform: {
                    updateColumns()
                    fi.sort(expr: "(+ ctime 0)")
                    fi.filter(expr: "(% ctime 2)")
                    fi.updateFiles()
                }
            )
        } else {
            NavigationSplitView {
            } detail: {
                NavigationStack(path: $navPath) {
                    VStack {
                        if (fiStoring == nil) {
                            NewConnectionView(connection: $fiStoring, navPath: $navPath)
                                .navigationTitle("Setup the main cache")
                                .navigationSubtitle("Where do you want to store the cache?")
                        } else {
                            Text("Setting up...")
                            .task {
                                fi.setup(storing: fiStoring!)
                            }
                        }
                    }
                }
            }
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

#Preview {
    ContentView()
}
