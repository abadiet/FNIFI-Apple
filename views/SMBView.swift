import SwiftUI

/*
struct SMBView : View {
    @ObservedObject var fi: FNIFIWrapper
    @State private var list: [SMB]
    @State private var server: String = ""
    @State private var share: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var storingPath: String = ""
    @State private var indexingPath: String = ""
    private var isFormValid: Bool {
        !server.isEmpty &&
        (storingPath != indexingPath)
    }

    init(fi: FNIFIWrapper) {
        self.fi = fi
        self.list = SMB.list()
    }

    var body: some View {
        List {
            Section(header: Text("Saved")) {
                ForEach(list) { smb in
                    HStack {
                        Button(action: {
                            do {
                                fi.use(coll: try smb.get())
                            } catch {
                                print("ERROR: Cannot find password for this collection")
                            }
                        }) {
                            Text(smb.getName())
                        }
                        Button(action: {
                            smb.delete()
                            list = SMB.list()
                        }) {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            Section(header: Text("New")) {
                TextField("Server Address", text: $server)
                    .disableAutocorrection(true)
                TextField("Share Name", text: $share)
                    .disableAutocorrection(true)
                TextField("Indexing Path", text: $indexingPath)
                    .disableAutocorrection(true)
                TextField("Storing Path", text: $storingPath)
                    .disableAutocorrection(true)
                TextField("Username", text: $username)
                    .disableAutocorrection(true)
                SecureField("Password", text: $password)
                Button(action: {
                    if isFormValid {
                        do {
                            fi.use(coll: try SMB.create(server: server, share: share, username: username, password: password, storingPath: storingPath, indexingPath: indexingPath))
                            fi.updateFiles()
                            server = ""
                            share = ""
                            indexingPath = ""
                            storingPath = ""
                            username = ""
                            password = ""
                        } catch SMB.SMBError.SaveToKeychain(let msg) {
                            print("ERROR: Failed to save password to keychain: \(msg)")
                        } catch {
                            print("ERROR: Failed to create collection")
                        }
                        list = SMB.list()
                    }
                }) {
                    Text("Save")
                }
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("SMB")
    }
}
*/
