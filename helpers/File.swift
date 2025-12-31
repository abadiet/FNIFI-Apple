import FNIFIModule
import Foundation
import CxxStdlib
import CoreLocation


struct File: Identifiable, Hashable {
    enum Kind {
        case BMP, GIF, JPEG2000, JPEG, PNG, WEBP, AVIF, PBM, PGM, PPM, PXM, PFM, SR, RAS, TIFF, EXR, HDR, PIC, MKV, AVI, MTS, MOV, WMV, YUV, MP4, M4V, UNKNOWN
    }
    
    let id = UUID()
    private let file: UnsafePointer<fnifi.file.File>
    
    init(file: UnsafePointer<fnifi.file.File>) {
        self.file = file
    }
    
    func getPath() -> String {
        return String(self.file.pointee.getPath())
    }
    
    func getLocalCopyPath() -> String {
        return String(self.file.pointee.getLocalCopyPath())
    }
    
    func getLocalPreviewPath() -> String {
        return String(self.file.pointee.getLocalPreviewPath())
    }
    
    func get(kind: Expression.Kind, key: String = "") -> Optional<Int64> {
        var result: fnifi.expr_t = 0
        if (file.pointee.get(&result, Expression.GetFNIFIKind(kind: kind), std.string(key))) {
            return Int64(result)
        }
        return nil
    }

    func getCoordinates() -> Optional<CLLocationCoordinate2D> {
        /* TODO: fnifi::file::Info optimization */
        let lat = get(kind: .LATITUDE)
        let lon = get(kind: .LONGITUDE)
        if let lat, let lon {
            return CLLocationCoordinate2D(latitude: Double(lat) / 3600000.0, longitude: Double(lon) / 3600000.0)
        }
        return nil
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
        case fnifi.file.MKV:
            return Kind.MKV
        case fnifi.file.AVI:
            return Kind.AVI
        case fnifi.file.MTS:
            return Kind.MTS
        case fnifi.file.MOV:
            return Kind.MOV
        case fnifi.file.WMV:
            return Kind.WMV
        case fnifi.file.YUV:
            return Kind.YUV
        case fnifi.file.MP4:
            return Kind.MP4
        case fnifi.file.M4V:
            return Kind.M4V
        case fnifi.file.UNKNOWN:
            return Kind.UNKNOWN
        default:
            return Kind.UNKNOWN
        }
    }
    
    static func extention(kind: Kind) -> String {
        switch kind {
        case .BMP:
            return "bmp"
        case .GIF:
            return "gid"
        case .JPEG2000:
            return "jp2"
        case .JPEG:
            return "jpg"
        case .PNG:
            return "png"
        case .WEBP:
            return "webp"
        case .AVIF:
            return "avif"
        case .PBM:
            return "pbm"
        case .PGM:
            return "pgm"
        case .PPM:
            return "ppm"
        case .PXM:
            return "pxm"
        case .PFM:
            return "pfm"
        case .SR:
            return "sr"
        case .RAS:
            return "ras"
        case .TIFF:
            return "tiff"
        case .EXR:
            return "exr"
        case .HDR:
            return "hdr"
        case .PIC:
            return "pic"
        case .MKV:
            return "mkv"
        case .AVI:
            return "avi"
        case .MTS:
            return "mts"
        case .MOV:
            return "mov"
        case .WMV:
            return "wmv"
        case .YUV:
            return "yuv"
        case .MP4:
            return "mp4"
        case .M4V:
            return "m4v"
        case .UNKNOWN:
            return ""
        }
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
