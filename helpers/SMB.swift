import FNIFIModule
import Foundation

/*
class SMB: Codable, Hashable, Identifiable {
    enum SMBError: Error {
        case SaveToKeychain(Any)
        case RetrieveFromKeychain(Any)
    }

    internal let id: UUID
    private let server: String
    private let share: String
    private let username: String
    private let indexingPath: String
    private let storingPath: String
    
    init(server: String, share: String, username: String, indexingPath: String, storingPath: String) {
        self.id = UUID()
        self.server = server
        self.share = share
        self.username = username
        self.indexingPath = indexingPath
        self.storingPath = storingPath
    }
    
    func getName() -> String {
        return "smb://\(username)@\(server)/\(share)/[\(indexingPath), \(storingPath)]"
    }

    static func create(
        server: String,
        share: String,
        username: String,
        password: String,
        storingPath: String,
        indexingPath: String
    ) throws -> (UnsafeMutablePointer<fnifi.connection.IConnection>, UnsafeMutablePointer<fnifi.connection.IConnection>)  {
        
        let smb = SMB(server: server, share: share, username: username, indexingPath: indexingPath, storingPath: storingPath)

        /* Save in Keychain */
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: smb.server,
            kSecAttrPath as String: smb.share,
            kSecAttrAccount as String: smb.username,
            kSecValueData as String: password.data(using: .utf8)!,
            kSecAttrSynchronizable as String: kCFBooleanTrue!,
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
            throw SMBError.SaveToKeychain(errorMessage)
        }

        /* Save in UserDefaults */
        let key = "SMB-\(smb.id)"
        if let encoded = try? JSONEncoder().encode(smb) {
            UserDefaults.standard.set(encoded, forKey: key)
        }

        return smb.get(password: password)
    }
    
    func delete() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecAttrPath as String: share,
            kSecAttrAccount as String: username,
            kSecAttrSynchronizable as String: kCFBooleanTrue!,
        ]
        SecItemDelete(query as CFDictionary)

        let key = "SMB-\(id)"
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func get() throws -> (UnsafeMutablePointer<fnifi.connection.IConnection>, UnsafeMutablePointer<fnifi.connection.IConnection>) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: self.server,
            kSecAttrPath as String: self.share,
            kSecAttrAccount as String: self.username,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        SecItemCopyMatching(query as CFDictionary, &item)
        guard item != nil else { throw SMBError.RetrieveFromKeychain(query) }
        let data = item as? Data
        let password = String(data: data!, encoding: .utf8)!

        return get(password: password)
    }
    
    private func get(password: String) -> (UnsafeMutablePointer<fnifi.connection.IConnection>, UnsafeMutablePointer<fnifi.connection.IConnection>) {
        let cppServer = std.string(server)
        let cppShare = std.string(share)
        let cppUsername = std.string(username)
        let cppPassword = std.string(password)

        let indexing = fnifi.connection.ConnectionBuilder.GetSMB(
            cppServer, cppShare, cppUsername, cppPassword,
            fnifi.connection.ConnectionBuilder.Options.init(relativePath: std.string(indexingPath))
        )!

        let storing = fnifi.connection.ConnectionBuilder.GetSMB(
            cppServer, cppShare, cppUsername, cppPassword,
            fnifi.connection.ConnectionBuilder.Options.init(relativePath: std.string(storingPath))
        )!

        return (indexing, storing)
    }

    static func list() -> [SMB] {
        let userDefaults = UserDefaults.standard
        var conns: [SMB] = []
        for key in userDefaults.dictionaryRepresentation().keys {
            if key.hasPrefix("SMB-"), let data = userDefaults.data(forKey: key) {
                if let conn = try? JSONDecoder().decode(SMB.self, from: data) {
                    conns.append(conn)
                }
            }
        }
        return conns
    }
    
    static func == (lhs: SMB, rhs: SMB) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
*/
