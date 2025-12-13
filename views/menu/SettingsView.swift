import SwiftUI


struct SettingsView: View {
    @ObservedObject var fi: FNIFIWrapper
    @State var defragmented: Bool = false
    @State var newCache: Bool = false
    
    init(fi: FNIFIWrapper) {
        self.fi = fi
    }
    
    var body: some View {
        if (!newCache) {
            VStack {
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
                    Text("Change Main Cache")
                }
            }
            .navigationTitle("Settings")
        } else {
            FNIFISetupView(fi: fi, onSetupFinished: {
                newCache = false
            })
        }
    }
}
