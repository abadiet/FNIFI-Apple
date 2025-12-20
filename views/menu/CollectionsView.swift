import SwiftUI


struct CollectionsView: View {
    @ObservedObject var fi: FNIFIWrapper
    @State private var newColl: Bool = false
    @State private var colls: [Collection]
    @State private var path = NavigationPath()
    
    init(fi: FNIFIWrapper) {
        self.fi = fi
        self.colls = Collection.List()
    }
    
    var body: some View {
        if (!newColl) {
            VStack {
                ForEach(colls) { coll in
                    let isUsed = fi.checkIsUsing(coll: coll)
                    HStack {
                        Button(action: {
                            fi.use(coll: coll)
                        }) {
                            Text(coll.name)
                        }
                        .disabled(isUsed)
                        Button(action: {
                            coll.delete()
                            colls = Collection.List()
                        }) {
                            Image(systemName: "trash")
                        }
                        .disabled(isUsed)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        newColl = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Collections")
        } else {
            NewCollectionView(fi: fi, onCollectionAdded: {
                colls = Collection.List()
                newColl = false
            })
        }
    }
}
