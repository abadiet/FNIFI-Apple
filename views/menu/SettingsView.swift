import SwiftUI


struct SettingsView: View {
    @ObservedObject var fi: FNIFIWrapper
    @State var defragmented: Bool = false
    @State var indexed: Bool = false
    @State var newCache: Bool = false
    @State var cacheCleared: Bool = false
    
    init(fi: FNIFIWrapper) {
        self.fi = fi
    }
    
    var body: some View {
        if (!newCache) {
            VStack {
                #if os(macOS)
                Button(action: {
                    indexed = true
                    fi.index()
                }) {
                    Text("Index")
                }
                .disabled(indexed)
                #endif
                Button(action: {
                    defragmented = true
                    fi.defragment()
                }) {
                    Text("Defragment")
                }
                .disabled(defragmented)
                Button(action: {
                    newCache = true
                }) {
                    Text("Change Main Storing location")
                }
                .disabled(defragmented)
                Button(action: {
                    cacheCleared = true
                    fi.clearCache()
                }) {
                    Text("Clear Local Cache")
                }
                .disabled(cacheCleared)
            }
            .navigationTitle("Settings")
        } else {
            FNIFISetupView(fi: fi, onSetupFinished: {
                newCache = false
            })
        }
    }
}
