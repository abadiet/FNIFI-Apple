import FNIFIModule
import SwiftUI
import CxxStdlib
internal import Combine


class Connection : Decodable, Encodable, ObservableObject {
    enum Kind: String, Codable {
        case Local = "local"
        case SMB = "smb"
        case None = "none"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, kind, server, share, username, path
    }

    var id = UUID()
    @Published var kind: Kind = Kind.None
    @Published var server: String = ""
    var share: String = ""
    var username: String = ""
    var password: String = ""
    var path: String = ""
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        kind = try container.decode(Kind.self, forKey: .kind)
        server = try container.decodeIfPresent(String.self, forKey: .server) ?? ""
        share = try container.decodeIfPresent(String.self, forKey: .share) ?? ""
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        path = try container.decodeIfPresent(String.self, forKey: .path) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encode(server, forKey: .server)
        try container.encode(share, forKey: .share)
        try container.encode(username, forKey: .username)
        try container.encode(path, forKey: .path)
    }

    func save(key: String = "") {
        var actualKey = key
        if actualKey == "" {
            actualKey = "Connection-\(id)"
        } else {
            /* Delete from UserDefaults */
            UserDefaults.standard.removeObject(forKey: actualKey)
        }

        /* Save in UserDefaults */
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: actualKey)
        }
        
        /* Save in Keychain */
        if (kind == .SMB) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: server,
                kSecAttrPath as String: share,
                kSecAttrAccount as String: username,
                kSecAttrProtocol as String: kSecAttrProtocolSMB,
                kSecValueData as String: password.data(using: .utf8)!,
                kSecAttrSynchronizable as String: kCFBooleanTrue!,
            ]
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
                print("ERROR: Failed to save password for an SMB connection: \(errorMessage)")
            }
        }
    }
    
    func build() -> UnsafeMutablePointer<fnifi.connection.IConnection>? {
        switch (kind) {
        case Kind.Local:
            return fnifi.connection.ConnectionBuilder.GetLocal(
                fnifi.connection.ConnectionBuilder.Options.init(relativePath: std.string(path))
            )
        case Kind.SMB:
            return fnifi.connection.ConnectionBuilder.GetSMB(
                std.string(server), std.string(share), std.string(username), std.string(password),
                fnifi.connection.ConnectionBuilder.Options.init(relativePath: std.string(path))
            )
        case Kind.None:
            return nil
        }
    }
    
    func delete() {
        /* Delete from UserDefaults */
        let key = "Connection-\(id)"
        UserDefaults.standard.removeObject(forKey: key)
        
        /* We keep the password in Keychain as we don't know if it is used somewhere else */
    }

    static func Get(key: String) -> Connection? {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let conn = try? JSONDecoder().decode(Connection.self, from: data) {
                
                if (conn.kind == .SMB) {
                    /* Retrieve password from Keychain */
                    let query: [String: Any] = [
                        kSecClass as String: kSecClassInternetPassword,
                        kSecAttrServer as String: conn.server,
                        kSecAttrPath as String: conn.share,
                        kSecAttrAccount as String: conn.username,
                        kSecAttrProtocol as String: kSecAttrProtocolSMB,
                        kSecAttrSynchronizable as String: kCFBooleanTrue!,
                        kSecReturnData as String: true,
                        kSecMatchLimit as String: kSecMatchLimitOne
                    ]
                    var item: CFTypeRef?
                    SecItemCopyMatching(query as CFDictionary, &item)
                    if let data = item as? Data {
                        if let password = String(data: data, encoding: .utf8) {
                            conn.password = password
                        }
                    }
                }
                return conn
            }
        }
        return nil
    }
    
    static func Get(id: UUID) -> Connection? {
        return Get(key: "Connection-\(id)")
    }
}
