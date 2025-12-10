import FNIFIModule

class CollectionPair {
    var coll: fnifi.file.Collection
    var storing: fnifi.utils.SyncDirectory

    init(
        indexing: UnsafeMutablePointer<fnifi.connection.IConnection>,
        storing: UnsafeMutablePointer<fnifi.connection.IConnection>
    ) {
        self.storing = fnifi.utils.SyncDirectory(storing, cachesPath)
        self.coll = fnifi.file.Collection(indexing, &self.storing)
    }
}
