import SwiftUI


struct ContentView: View {
    @StateObject private var fi = FNIFIWrapper()
    
    private enum Menu {
        case collections, sort, filter, grid, settings
    }
    @State private var menu: Menu? = .grid

    var body: some View {
        if (fi.isSetup) {
            NavigationSplitView {
                List(selection: $menu) {
                    NavigationLink(value: Menu.grid) {
                        Label("Grid", systemImage: "photo.on.rectangle")
                    }
                    NavigationLink(value: Menu.collections) {
                        Label("Collections", systemImage: "rectangle.stack")
                    }
                    NavigationLink(value: Menu.sort) {
                        Label("Sort", systemImage: "list.dash")
                    }
                    NavigationLink(value: Menu.filter) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }
                    NavigationLink(value: Menu.settings) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            } detail: {
                NavigationStack {
                    switch menu {
                    case .collections:
                        CollectionsView(fi: fi)
                    case .sort:
                        ExpressionsView<SortExpr>(fi: fi)
                    case .filter:
                        ExpressionsView<FilterExpr>(fi: fi)
                    case .grid:
                        GridView(files: $fi.files)
                            .ignoresSafeArea(.all)
                    case .settings:
                        SettingsView(fi: fi)
                    case .none:
                        EmptyView()
                    }
                }
            }
        } else {
            FNIFISetupView(fi: fi)
        }
    }
}
