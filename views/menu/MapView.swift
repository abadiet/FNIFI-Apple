import SwiftUI
import FNIFIModule
import MapKit


struct MapView: View {
    @Binding var files: [File]
    @State private var selectedFile: File?
    let sizeAnnot: CGFloat = 50.0
    let sizeImg: CGFloat = 46.0
    let radius: CGFloat = 4.0
    
    var body: some View {
        ZStack {
            Map {
                ForEach(files) { file in
                    if let coords = file.getCoordinates() {
                        Annotation(coordinate: coords, content: {
                            ZStack {
                                RoundedRectangle(cornerRadius: radius)
                                    .fill(.white)
                                    .frame(width: sizeAnnot, height: sizeAnnot)
                                PreviewView(file: file, width: sizeImg, height: sizeImg, selectedFile: $selectedFile)
                                    .cornerRadius(radius)
                            }
                        }, label: {
                            
                        })
                    }
                }
            }
            
            if selectedFile != nil {
                DetailedView(selectedFile: $selectedFile)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .toolbarBackgroundVisibility(.hidden, for: .automatic)
        .navigationTitle("")
    }
}
