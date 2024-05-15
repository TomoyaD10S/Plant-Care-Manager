import SwiftUI
import UIKit

struct AddImageView: View {
    let name: String
    let onClose: () -> Void
    
    @State private var plantImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isSaveImage = false
    @State private var showConfirmationAlertImage = false
    @Binding var isAddImageViewPresented: Bool
    
    
    @ObservedObject var plantData: PlantData
    
    public init(name: String, plantData: PlantData, isAddImageViewPresented: Binding<Bool>, onClose: @escaping () -> Void) {
        self.name = name
        self.plantData = plantData
        self._isAddImageViewPresented = isAddImageViewPresented
        self.onClose = onClose
    }
    
    private func loadImage() {
        guard let plant = plantData.plants.first(where: { $0.plantType == name }),
              let imageData = plant.image,
              let uiImage = UIImage(data: imageData) else { return }
        plantImage = uiImage
    }
    
    var body: some View {
        NavigationView {
            Group {
                ZStack {
                    Image("23")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    
                    if let image = plantImage {
                        VStack{
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                            
                            Spacer().frame(height:20)
                            
                            Button("Choose other Photo") {
                                isShowingImagePicker = true
                            }
                            .sheet(isPresented: $isShowingImagePicker) {
                                ImagePicker(selectedImage: $plantImage)
                            }
                            
                            Spacer().frame(height:20)
                            
                            Button("Save Photo") {
                                if let image = plantImage,
                                   let imageData = image.jpegData(compressionQuality: 0.5) {
                                    if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                        plantData.plants[index].image = imageData
                                        plantData.savePlants()
                                        onClose()
                                    }
                                }
                            }
                            
                            Spacer().frame(height:20)
                            
                            Button("Delete Photo") {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].image = nil
                                    plantData.savePlants()
                                    print(plantData.plants[index])
                                    onClose()
                                }
                            }
                        }
                    } else {
                        Button("Add New Photo") {
                            isShowingImagePicker = true
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(selectedImage: $plantImage)
                        }
                    }
                }
                .onAppear {
                    loadImage()
                }
            }
            .navigationTitle("Image")
            .navigationBarItems(trailing: Button("Cancel") {
                isAddImageViewPresented = false
            })
        }
    }
}

