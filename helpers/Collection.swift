import FNIFIModule
import SwiftUI
import Foundation


class Collection : Encodable, Decodable, Identifiable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case id, indexingId, storingId, name
    }

    internal var id = UUID()
    private let indexingId: UUID
    private let storingId: UUID
    let name: String
    let indexing: Connection
    let storing: Connection
    
    init() {
        self.indexingId = UUID()
        self.storingId = UUID()
        self.name = ""
        self.indexing = Connection()
        self.storing = Connection()
    }
    
    init(indexing: Connection, storing: Connection, name: String) {
        self.indexing = indexing
        self.storing = storing
        self.indexingId = self.indexing.id
        self.storingId = self.storing.id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        indexingId = try container.decode(UUID.self, forKey: .indexingId)
        storingId = try container.decode(UUID.self, forKey: .storingId)
        name = try container.decode(String.self, forKey: .name)
        
        indexing = Connection.Get(id: indexingId)!
        storing = Connection.Get(id: storingId)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(indexingId, forKey: .indexingId)
        try container.encode(storingId, forKey: .storingId)
        try container.encode(name, forKey: .name)
    }
    
    func save() {
        indexing.save()
        storing.save()

        /* Save in UserDefaults */
        let key = "Collection-\(id)"
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func delete() {
        /* Delete from UserDefaults */
        let key = "Collection-\(id)"
        UserDefaults.standard.removeObject(forKey: key)
        
        indexing.delete()
        storing.delete()
    }
    
    static func List() -> [Collection] {
        var colls: [Collection] = []
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.hasPrefix("Collection-"), let data = UserDefaults.standard.data(forKey: key) {
                if let coll = try? JSONDecoder().decode(Collection.self, from: data) {
                    colls.append(coll)
                }
            }
        }
        return colls
    }
    
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
