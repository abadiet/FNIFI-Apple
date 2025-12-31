import SwiftUI
import FNIFIModule
import MapKit
import CoreLocation


struct MapView: View {
    @Binding var files: [File]
    @State private var selectedFile: File?
    @State private var coordsFiles = [(file: File, coords: CLLocationCoordinate2D)]()
    @State private var noCoordsFiles = [File]()
    @State private var gridIsActive: Bool = false
    let sizeAnnot: CGFloat = 50.0
    let sizeImg: CGFloat = 46.0
    let radius: CGFloat = 4.0

    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Map {
                    ForEach(coordsFiles, id: \.file) { (file, coords) in
                        Annotation(coordinate: coords, content: {
                            ZStack {
                                RoundedRectangle(cornerRadius: radius)
                                    .fill(.white)
                                    .frame(width: sizeAnnot, height: sizeAnnot)
                                PreviewView(file: file, width: sizeImg, height: sizeImg, selectedFile: $selectedFile)
                                    .cornerRadius(radius)
                            }
                        }, label: { })
                    }
                }
                
                if selectedFile != nil {
                    DetailedView(selectedFile: $selectedFile)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .onAppear {
                updateFilesArrays()
            }
            .onChange(of: files) {
                updateFilesArrays()
            }
            .sheet(isPresented: $gridIsActive) {
                GridView(files: $noCoordsFiles)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .presentationDetents([.large])
            }
            .toolbar {
                if (noCoordsFiles.count > 0) {
                    ToolbarItem(placement: .automatic, content: {
                        Button(action: {
                            gridIsActive = true
                        }, label: {
                            HStack {
                                Text(String(noCoordsFiles.count))
                                Image(systemName: "mappin.slash")
                            }
                        })
                    })
                }
            }
            .toolbarBackgroundVisibility(.hidden, for: .automatic)
            .navigationTitle("")
        }
    }
    
    private func updateFilesArrays() {
        coordsFiles.removeAll()
        noCoordsFiles.removeAll()
        for file in files {
            if let coords = file.getCoordinates() {
                coordsFiles.append((file, coords))
            } else {
                noCoordsFiles.append(file)
            }
        }
    }
}
