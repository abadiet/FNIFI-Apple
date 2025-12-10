import SwiftUI
import FNIFIModule


struct NewCollectionView: View {
    @ObservedObject var fi: FNIFIWrapper
    @ObservedObject private var indexing = Connection()
    @ObservedObject private var storing = Connection()
    @State private var path = NavigationPath()
    @State private var name: String = ""
    @State private var tmpName: String = ""
    private var onCollectionAdded: (() -> Void)?
    
    init(fi: FNIFIWrapper, onCollectionAdded: (() -> Void)? = nil) {
        self.fi = fi
        self.onCollectionAdded = onCollectionAdded
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if (indexing.kind == Connection.Kind.None) {
                    NewConnectionView(connection: indexing, navPath: $path)
                        .navigationTitle("Indexing 1/3")
                        .navigationSubtitle("What do you want to index?")
                } else if (storing.kind == Connection.Kind.None) {
                    NewConnectionView(connection: storing, navPath: $path)
                        .navigationTitle("Storing 2/3")
                        .navigationSubtitle("Where do you want to store the cache?")
                } else if (name == "") {
                    TextField("Name", text: $tmpName)
                        .disableAutocorrection(true)
                        .navigationTitle("Name 3/3")
                        .navigationSubtitle("Give it a name")
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button(action: {
                                    name = tmpName
                                }) {
                                    Image(systemName: "checkmark")
                                }
                                .disabled(tmpName.isEmpty)
                            }
                        }
                } else {
                    Text("Collection successfuly added!")
                        .task({
                            let coll = Collection(indexing: indexing, storing: storing, name: name)
                            fi.use(coll: coll)
                            coll.save()
                            fi.updateFiles()
                            onCollectionAdded?()
                        })
                }
            }
        }
    }
}
