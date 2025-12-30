import FNIFIModule
import Foundation
import CxxStdlib


struct Expression {
    enum Kind {
        case KIND, SIZE, CTIME, MTIME, WIDTH, HEIGHT, DURATION, LATITUDE, LONGITUDE, ALTITUDE, XMP, EXIF, IPTC, UNKNOWN
    }
    
    static func GetFNIFIKind(kind: Kind) -> fnifi.expression.Kind {
        switch kind {
        case .KIND:
            return fnifi.expression.KIND
        case .SIZE:
            return fnifi.expression.SIZE
        case .CTIME:
            return fnifi.expression.CTIME
        case .MTIME:
            return fnifi.expression.MTIME
        case .WIDTH:
            return fnifi.expression.WIDTH
        case .HEIGHT:
            return fnifi.expression.HEIGHT
        case .DURATION:
            return fnifi.expression.DURATION
        case .LATITUDE:
            return fnifi.expression.LATITUDE
        case .LONGITUDE:
            return fnifi.expression.LONGITUDE
        case .ALTITUDE:
            return fnifi.expression.ALTITUDE
        case .XMP:
            return fnifi.expression.XMP
        case .EXIF:
            return fnifi.expression.EXIF
        case .IPTC:
            return fnifi.expression.IPTC
        case .UNKNOWN:
            return fnifi.expression.UNKNOWN
        }
    }
}
