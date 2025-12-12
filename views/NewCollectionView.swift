import SwiftUI
internal import Combine


struct NewCollectionView: View {
    @ObservedObject var fi: FNIFIWrapper
    @ObservedObject private var indexing = Connection()
    @ObservedObject private var storing = Connection()
    @State private var path = NavigationPath()
    @State private var name: String = ""
    @State private var tmpName: String = ""
    @State private var maxCopiesSz: Int = 0
    @State private var tmpmaxCopiesSz: String = ""
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
                    List {
                        TextField("Name", text: $tmpName)
                            .disableAutocorrection(true)
                        TextField("Local cache size (default to 1024000000 bytes)", text: $tmpmaxCopiesSz)
                            .onReceive(Just(tmpmaxCopiesSz)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    tmpmaxCopiesSz = filtered
                                }
                            }
                            .disableAutocorrection(true)
                    }
                    .navigationTitle("Miscellaneous 3/4")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {
                                name = tmpName
                                maxCopiesSz = Int(tmpmaxCopiesSz) ?? 1024000000
                                if (maxCopiesSz <= 0) {
                                    maxCopiesSz = 1024000000
                                }
                            }) {
                                Image(systemName: "checkmark")
                            }
                            .disabled(tmpName.isEmpty)
                        }
                    }
                } else {
                    Text("Collection being added...")
                        .task({
                            let coll = Collection(indexing: indexing, storing: storing, name: name, maxCopiesSz: maxCopiesSz)
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
