import SwiftUI

struct EditInfoView: View {
    @ObservedObject var plantData: PlantData
    @State private var IsEditInfo = false
    @State private var showConfirmation = false
    @Binding var isEditInfoView: Bool
    
    let name: String
    let idx: Int
    
    @State private var textContent = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    TextEditor(text: $textContent)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .border(Color.gray)
                    
                    Button("Save") {
                        showConfirmation.toggle()
                    }
                    .alert(isPresented: $showConfirmation) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Are you sure you want to save ?"),
                            primaryButton: .default(Text("Yes")
                                .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255)))
                            {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].Info[idx] = textContent
                                }
                                plantData.savePlants()
                                isEditInfoView = false
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                }
                .background{
                    Image("23")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                }
                .padding()
                .navigationBarTitle("Edit Information")
                .onAppear {
                    if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                        textContent = plantData.plants[index].Info[idx]
                    }
                }
            }
        }
    }
}

