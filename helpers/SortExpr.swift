import Foundation
import SwiftUI


struct SortExpr : Encodable, Decodable, Identifiable, ExpressionProtocol {
    private enum CodingKeys: String, CodingKey {
        case id, name, expression
    }

    static let className: String = "Sort"
    var id = UUID()
    var name: String = ""
    var expression: String = ""
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        expression = try container.decode(String.self, forKey: .expression)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(expression, forKey: .expression)
    }
    
    func use(fi: FNIFIWrapper) {
        fi.sort(expr: expression)
        fi.updateFiles()
    }
    
    func isUsed(fi: FNIFIWrapper) -> Bool {
        return fi.isSortingExpr(expr: expression)
    }
    
    func save() {
        /* Save in UserDefaults */
        let key = "\(SortExpr.className)-\(id)"
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func delete() {
        /* Delete from UserDefaults */
        let key = "\(SortExpr.className)-\(id)"
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func List() -> [SortExpr] {
        var exprs: [SortExpr] = []
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.hasPrefix("\(SortExpr.className)-"), let data = UserDefaults.standard.data(forKey: key) {
                if let expr = try? JSONDecoder().decode(SortExpr.self, from: data) {
                    exprs.append(expr)
                }
            }
        }
        return exprs
    }
}
