import SwiftUI


struct NewConnectionView : View {
    @ObservedObject var connection: Connection
    @Binding var navPath: NavigationPath

    var body: some View {
        List {
            NavigationLink("Local", value: Connection.Kind.Local)
            NavigationLink("SMB", value: Connection.Kind.SMB)
        }
        .navigationDestination(for: Connection.Kind.self) { kind in
            switch kind {
            case Connection.Kind.Local:
                List {
                    Text("Tips:\n- Documents: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path())\n- Downloads: \(FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.path())\n- Desktop: \(FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path())\n- Movies: \(FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask).first!.path())\n- Music: \(FileManager.default.urls(for: .musicDirectory, in: .userDomainMask).first!.path())\n- Pictures: \(FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path())")
                    TextField("Path", text: $connection.path)
                        .disableAutocorrection(true)
                }
                .navigationTitle("Local")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            connection.kind = kind
                            navPath.removeLast()
                        }) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            case Connection.Kind.SMB:
                List {
                    TextField("Server Address", text: $connection.server)
                        .disableAutocorrection(true)
                    TextField("Share Name", text: $connection.share)
                        .disableAutocorrection(true)
                    TextField("Path", text: $connection.path)
                        .disableAutocorrection(true)
                    TextField("Username", text: $connection.username)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $connection.password)
                }
                .navigationTitle("SMB")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            connection.kind = kind
                            navPath.removeLast()
                        }) {
                            Image(systemName: "checkmark")
                        }
                        .disabled(connection.server.isEmpty)
                    }
                }
            case Connection.Kind.None:
                Text("Select a connection mode")
            }
        }
    }
}
