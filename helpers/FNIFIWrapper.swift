import FNIFIModule
import SwiftUI
import CxxStdlib
internal import Combine


let cachesPath = std.string(FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path())
let appID: String = "eu.tabadie.FNIFI-Apple"

class FNIFIWrapper : ObservableObject {
    @Published var isSetup: Bool
    private var fi: fnifi.FNIFI?
    private var storing: fnifi.utils.SyncDirectory?
    private var colls = [CollectionPair]()
    @Published var files = [UnsafePointer<fnifi.file.File>]()
    
    init() {
        /* Load from UserDefaults */
        isSetup = false
        if let storing = Connection.get(key: "FNIFI") {
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

    func use(indexing: Connection, storing: Connection) {
        if let ind = indexing.build() {
            if let stor = storing.build() {
                let index = self.colls.count
                self.colls.append(CollectionPair(indexing: ind, storing: stor))
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

    func updateFiles() {
        self.files.removeAll()
        self.fi!.getFiles().forEach({ file in
            self.files.append(file!)
        })
    }
}
