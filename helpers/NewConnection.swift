import FNIFIModule
import CxxStdlib


class NewConnection {
    static func Local(
        path: String,
    ) -> UnsafeMutablePointer<fnifi.connection.IConnection> {
        return fnifi.connection.ConnectionBuilder.GetLocal(
            fnifi.connection.ConnectionBuilder.Options.init(relativePath: std.string(path))
        )
    }

    static func SMB(
        server: String,
        share: String,
        username: String,
        password: String,
        path: String,
    ) -> UnsafeMutablePointer<fnifi.connection.IConnection> {
        return fnifi.connection.ConnectionBuilder.GetSMB(
            std.string(server), std.string(share), std.string(username), std.string(password),
            fnifi.connection.ConnectionBuilder.Options.init(relativePath: std.string(path))
        )
    }
}
