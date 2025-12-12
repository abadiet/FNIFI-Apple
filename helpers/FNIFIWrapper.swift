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
            maxCopiesSz: Int
        ) {
            self.id = id
            self.storing = fnifi.utils.SyncDirectory(storing, cachesPath)
            self.coll = fnifi.file.Collection(indexing, &self.storing, maxCopiesSz)
        }
    }
    
    @Published var isSetup: Bool
    private var fi: fnifi.FNIFI?
    private var storing: fnifi.utils.SyncDirectory?
    private var colls = [CollectionPair]()
    @Published var files = [File]()
    private var sortExpr: String = ""
    private var filterExpr: String = ""
    
    init() {
        /* Load from UserDefaults */
        isSetup = false
        if let storing = Connection.Get(key: "FNIFI") {
            setup(storing: storing)
        }
    }

    func setup(storing: Connection) {
        if let stor = storing.build() {
            self.colls.removeAll()
            self.files.removeAll()
            self.sortExpr = ""
            self.filterExpr = ""
            self.storing = fnifi.utils.SyncDirectory(stor, cachesPath)
            self.fi = fnifi.FNIFI(&self.storing!)
            updateFiles()
            isSetup = true
        }
    }

    func use(coll: Collection) {
        if let ind = coll.indexing.build() {
            if let stor = coll.storing.build() {
                let index = self.colls.count
                self.colls.append(CollectionPair(id: coll.id, indexing: ind, storing: stor, maxCopiesSz: coll.maxCopiesSz))
                self.fi!.addCollection(&self.colls[index].coll)
            }
        }
    }

    func sort(expr: String) {
        self.fi!.sort(std.string(expr))
        sortExpr = expr
    }
    
    func isSortingExpr(expr: String) -> Bool {
        return expr == sortExpr
    }

    func filter(expr: String) {
        self.fi!.filter(std.string(expr))
        filterExpr = expr
    }
    
    func isFilteringExpr(expr: String) -> Bool {
        return expr == filterExpr
    }
    
    func defragment() {
        self.fi!.defragment()
    }

    func updateFiles() {
        self.files.removeAll()
        self.fi!.getFiles().forEach({ file in
            if let f = file {
                self.files.append(File(file: f))
            }
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
