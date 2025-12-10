import SwiftUI
import FNIFIModule


struct NewCollectionView: View {
    @ObservedObject var fi: FNIFIWrapper
    @ObservedObject private var indexing = Connection()
    @ObservedObject private var storing = Connection()
    @State private var path = NavigationPath()
    
    init(fi: FNIFIWrapper) {
        self.fi = fi
    }    

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if (indexing.kind == Connection.Kind.None) {
                    NewConnectionView(connection: indexing, navPath: $path)
                        .navigationTitle("Indexing 1/2")
                        .navigationSubtitle("What do you want to index?")
                } else if (storing.kind == Connection.Kind.None) {
                    NewConnectionView(connection: storing, navPath: $path)
                        .navigationTitle("Storing 2/2")
                        .navigationSubtitle("Where do you want to store the cache?")
                } else {
                    Text("Collection successfuly added!")
                        .task({
                            fi.use(indexing: indexing, storing: storing)
                            fi.updateFiles()
                        })
                }
            }
        }
    }
}
