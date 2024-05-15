import SwiftUI

struct EditNameView: View {
    @ObservedObject var plantData: PlantData
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var newPlantName = ""
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String
    
    let Account: String
    let prePlantName: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Plant Name")) {
                    TextField("Enter new plant name", text: $newPlantName)
                }
                .listRowBackground(
                    Image("23")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.98)
                )
                
                Section {
                    Button("Save") {
                        print(newPlantName)
                        savePlant()
                    }
                    .disabled(newPlantName == "" || newPlantName == prePlantName)
                }
                .listRowBackground(
                    Image("23")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.98)
                )
            }
            .background{
                Image("8")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationTitle("Edit Plant Name")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Edit Name Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    
    private func savePlant() {

        guard !newPlantName.isEmpty else {
            return
        }

        guard !plantData.plants.contains(where: { $0.plantType == newPlantName }) else {
            alertMessage = "Plant with the same name already exists."
            showAlert = true
            return
        }
        
        if let index = plantData.plants.firstIndex(where: { $0.plantType == prePlantName }) {
            plantData.plants[index].plantType = newPlantName
            plantData.savePlants()
            updateName(name: prePlantName, newName: newPlantName)
            name = newPlantName
        }
        presentationMode.wrappedValue.dismiss()
    }
}

