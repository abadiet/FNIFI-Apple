import SwiftUI
import FNIFIModule


struct NewCollectionView: View {
    @ObservedObject var fi: FNIFIWrapper
    @State private var indexing: UnsafeMutablePointer<fnifi.connection.IConnection>?
    @State private var storing: UnsafeMutablePointer<fnifi.connection.IConnection>?
    @State private var path = NavigationPath()
    
    init(fi: FNIFIWrapper) {
        self.fi = fi
    }    

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if (indexing == nil) {
                    NewConnectionView(connection: $indexing, navPath: $path)
                        .navigationTitle("Indexing 1/2")
                        .navigationSubtitle("What do you want to index?")
                } else if (storing == nil) {
                    NewConnectionView(connection: $storing, navPath: $path)
                        .navigationTitle("Storing 2/2")
                        .navigationSubtitle("Where do you want to store the cache?")
                } else {
                    let _ = fi.use(indexing: indexing!, storing: storing!)
                    let _ = fi.updateFiles()
                    Text("Collection successfuly added!")
                }
            }
        }
    }
}
