import SwiftUI
import FNIFIModule


struct NewConnectionView : View {
    private enum Kind {
        case Local, SMB
    }
    
    @Binding var connection: UnsafeMutablePointer<fnifi.connection.IConnection>?
    @Binding var navPath: NavigationPath
    @State private var server: String = ""
    @State private var share: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var path: String = ""
    

    var body: some View {
        List {
            NavigationLink("Local", value: Kind.Local)
            NavigationLink("SMB", value: Kind.SMB)
        }
        .navigationDestination(for: Kind.self) { value in
            switch value {
            case Kind.Local:
                List {
                    Text("Tips:\n- Documents: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path())\n- Downloads: \(FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.path())\n- Desktop: \(FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path())\n- Movies: \(FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask).first!.path())\n- Music: \(FileManager.default.urls(for: .musicDirectory, in: .userDomainMask).first!.path())\n- Pictures: \(FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path())")
                    TextField("Path", text: $path)
                        .disableAutocorrection(true)
                }
                .navigationTitle("Local")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            connection = NewConnection.Local(path: path)
                            navPath.removeLast()
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                }
            case Kind.SMB:
                List {
                    TextField("Server Address", text: $server)
                        .disableAutocorrection(true)
                    TextField("Share Name", text: $share)
                        .disableAutocorrection(true)
                    TextField("Path", text: $path)
                        .disableAutocorrection(true)
                    TextField("Username", text: $username)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $password)
                }
                .navigationTitle("SMB")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            connection = NewConnection.Local(path: path)
                            navPath.removeLast()
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .disabled(server.isEmpty)
                    }
                }
            }
        }
    }
}
