import FNIFIModule
import Foundation


struct File: Identifiable, Hashable {
    enum Kind {
        case BMP, GIF, JPEG2000, JPEG, PNG, WEBP, AVIF, PBM, PGM, PPM, PXM, PFM, SR, RAS, TIFF, EXR, HDR, PIC, UNKNOWN
    }
    
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
    
    func getKind() -> Kind {
        switch file.pointee.getKind() {
        case fnifi.file.BMP:
            return Kind.BMP
        case fnifi.file.GIF:
            return Kind.GIF
        case fnifi.file.JPEG2000:
            return Kind.JPEG2000
        case fnifi.file.JPEG:
            return Kind.JPEG
        case fnifi.file.PNG:
            return Kind.PNG
        case fnifi.file.WEBP:
            return Kind.WEBP
        case fnifi.file.AVIF:
            return Kind.AVIF
        case fnifi.file.PBM:
            return Kind.PBM
        case fnifi.file.PGM:
            return Kind.PGM
        case fnifi.file.PPM:
            return Kind.PPM
        case fnifi.file.PXM:
            return Kind.PXM
        case fnifi.file.PFM:
            return Kind.PFM
        case fnifi.file.SR:
            return Kind.SR
        case fnifi.file.RAS:
            return Kind.RAS
        case fnifi.file.TIFF:
            return Kind.TIFF
        case fnifi.file.EXR:
            return Kind.EXR
        case fnifi.file.HDR:
            return Kind.HDR
        case fnifi.file.PIC:
            return Kind.PIC
        case fnifi.file.UNKNOWN:
            return Kind.UNKNOWN
        default:
            return Kind.UNKNOWN
        }
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
