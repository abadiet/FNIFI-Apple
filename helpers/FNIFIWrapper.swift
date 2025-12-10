import FNIFIModule
import SwiftUI
import CxxStdlib
internal import Combine


let cachesPath = std.string(FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path())
let appID: String = "eu.tabadie.FNIFI-Apple"

class FNIFIWrapper : ObservableObject {
    private class CollectionPair {
        let id: UUID
        var coll: fnifi.file.Collection
        var storing: fnifi.utils.SyncDirectory

        init(
            id: UUID,
            indexing: UnsafeMutablePointer<fnifi.connection.IConnection>,
            storing: UnsafeMutablePointer<fnifi.connection.IConnection>,
        ) {
            self.id = id
            self.storing = fnifi.utils.SyncDirectory(storing, cachesPath)
            self.coll = fnifi.file.Collection(indexing, &self.storing)
        }
    }
    
    @Published var isSetup: Bool
    private var fi: fnifi.FNIFI?
    private var storing: fnifi.utils.SyncDirectory?
    private var colls = [CollectionPair]()
    @Published var files = [UnsafePointer<fnifi.file.File>]()
    
    init() {
        /* Load from UserDefaults */
        isSetup = false
        if let storing = Connection.Get(key: "FNIFI") {
            setup(storing: storing)
        }
    }

    func setup(storing: Connection) {
        if let stor = storing.build() {
            self.storing = fnifi.utils.SyncDirectory(stor, cachesPath)
            self.fi = fnifi.FNIFI(&self.storing!)
            isSetup = true
        }
    }

    func use(coll: Collection) {
        if let ind = coll.indexing.build() {
            if let stor = coll.storing.build() {
                let index = self.colls.count
                self.colls.append(CollectionPair(id: coll.id, indexing: ind, storing: stor))
                self.fi!.addCollection(&self.colls[index].coll)
            }
        }
    }

    func sort(expr: String) {
        self.fi!.sort(std.string(expr))
    }

    func filter(expr: String) {
        self.fi!.filter(std.string(expr))
    }
    
    func defragment() {
        self.fi!.defragment()
    }

    func updateFiles() {
        self.files.removeAll()
        self.fi!.getFiles().forEach({ file in
            self.files.append(file!)
        })
    }
    
    func checkIsUsing(coll: Collection) -> Bool {
        for c in colls {
            if (coll.id == c.id) {
                return true
            }
        }
        return false
    }
}
