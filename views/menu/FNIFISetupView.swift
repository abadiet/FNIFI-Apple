import SwiftUI


struct FNIFISetupView: View {
    @ObservedObject var fi: FNIFIWrapper
    @StateObject var fiStoring = Connection()
    @State var path = NavigationPath()
    private var onSetupFinished: (() -> Void)?
    
    init(fi: FNIFIWrapper, onSetupFinished: (() -> Void)? = nil) {
        self.fi = fi
        self.onSetupFinished = onSetupFinished
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if (fiStoring.kind == Connection.Kind.None) {
                    NewConnectionView(connection: fiStoring, navPath: $path)
                        .navigationTitle("Setup the main cache")
                        .navigationSubtitle("Where do you want to store the cache?")
                } else {
                    Text("Setting up...")
                        .task {
                            fi.setup(storing: fiStoring)
                            fiStoring.save(key: "FNIFI")
                            onSetupFinished?()
                        }
                }
            }
        }
    }
}
