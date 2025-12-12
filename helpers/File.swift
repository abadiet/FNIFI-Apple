import FNIFIModule
import Foundation


struct File: Identifiable, Hashable {
    let id = UUID()
    private let file: UnsafePointer<fnifi.file.File>
    
    init(file: UnsafePointer<fnifi.file.File>) {
        self.file = file
    }
    
    func getLocalCopyPath() -> String {
        return String(self.file.pointee.getLocalCopyPath())
    }
    
    func getLocalPreviewPath() -> String {
        return String(self.file.pointee.getLocalPreviewPath())
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
