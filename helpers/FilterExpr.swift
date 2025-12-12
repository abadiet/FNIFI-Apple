import Foundation
import SwiftUI


struct FilterExpr : Encodable, Decodable, Identifiable, ExpressionProtocol {
    private enum CodingKeys: String, CodingKey {
        case id, name, expression
    }

    static let className: String = "Filter"
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
        fi.filter(expr: expression)
        fi.updateFiles()
    }
    
    func isUsed(fi: FNIFIWrapper) -> Bool {
        return fi.isFilteringExpr(expr: expression)
    }
    
    func save() {
        /* Save in UserDefaults */
        let key = "\(FilterExpr.className)-\(id)"
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func delete() {
        /* Delete from UserDefaults */
        let key = "\(FilterExpr.className)-\(id)"
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func List() -> [FilterExpr] {
        var exprs: [FilterExpr] = []
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.hasPrefix("\(FilterExpr.className)-"), let data = UserDefaults.standard.data(forKey: key) {
                if let expr = try? JSONDecoder().decode(FilterExpr.self, from: data) {
                    exprs.append(expr)
                }
            }
        }
        return exprs
    }
}
