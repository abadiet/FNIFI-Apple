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
                    NavigationLink("Grid", value: Menu.grid)
                    NavigationLink("Collections", value: Menu.collections)
                    NavigationLink("Sort", value: Menu.sort)
                    NavigationLink("Filter", value: Menu.filter)
                    NavigationLink("Settings", value: Menu.settings)
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
                    case .settings:
                        SettingsView(fi: fi)
                    case .none:
                        Text("Select an entry in the menu")
                    }
                }
            }
        } else {
            NavigationSplitView {
            } detail: {
                FNIFISetupView(fi: fi)
            }
        }
    }
}

#Preview {
    ContentView()
}
