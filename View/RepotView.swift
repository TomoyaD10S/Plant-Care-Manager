import SwiftUI

struct RepotView: View {
    @ObservedObject var plantData: PlantData
    @Binding var isRepodView: Bool
    @State private var potSizeInput_num1 = ""
    @State private var potSizeInput_num2 = ""
    @State private var potSizeInput_unit = "cm"
    @State private var showConfirmation = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let name: String
    let account: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack {
                    Text("Potsize requires both an integer and a decimal value.")
                    
                    HStack{
                        TextField("00", text: $potSizeInput_num1)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text(".")
                        TextField("00", text: $potSizeInput_num2)
                            .keyboardType(.numberPad)
                    }
                    Picker("Select Language", selection: $potSizeInput_unit) {
                        Text("cm").tag("cm")
                        Text("L").tag("L")
                        Text("Inch").tag("Inch")
                        Text("Gallon").tag("Gallon")
                    }
                    .background(Color.black.opacity(0))
                    .frame(width: 200, height: 200)
                    .pickerStyle(WheelPickerStyle())
                    
                    Button(action: {
                        showConfirmation.toggle()
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 18/255, green: 83/255, blue: 20/255))
                            .cornerRadius(10)
                    }
                    .disabled((potSizeInput_num1.isEmpty && potSizeInput_num2.isEmpty) || (!potSizeInput_num1.isEmpty && potSizeInput_num2.isEmpty) || (potSizeInput_num1.isEmpty && !potSizeInput_num2.isEmpty) || (!potSizeInput_num1.allSatisfy { $0.isNumber } || !potSizeInput_num2.allSatisfy { $0.isNumber } ))
                    .buttonStyle(BorderlessButtonStyle())
                    .alert(isPresented: $showConfirmation) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Are you sure you want to save ?"),
                            primaryButton: .default(Text("Yes")) {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].potsize_num = String(potSizeInput_num1 + "." + potSizeInput_num2)
                                    plantData.plants[index].potsize_unit = potSizeInput_unit
                                    
                                }
                                
                                if !potSizeInput_num1.isEmpty && !potSizeInput_num2.isEmpty{
                                    addPotItemToDataList(forName:name, potsize: String(potSizeInput_num1 + "." + potSizeInput_num2), potunit: potSizeInput_unit, andDate: Date())
                                }
                                plantData.savePlants()
                                potSizeInput_num1 = ""
                                potSizeInput_num2 = ""
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                }
                .navigationBarTitle("Repot")
                .navigationBarItems(trailing:
                                        Button(action: {
                    isRepodView = false
                    potSizeInput_num1 = ""
                    potSizeInput_num2 = ""
                }) {
                    Text("Back")
                        .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                }
                )
            }
        }
    }
}
