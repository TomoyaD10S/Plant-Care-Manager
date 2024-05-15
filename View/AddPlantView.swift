import SwiftUI

struct AddPlantView: View {
    @Binding var newPlantName: String
    @Binding var defaultIntervalWatering: Int
    @Binding var defaultIntervalFertilizingDormancy: Int
    @Binding var defaultIntervalFertilizingActiveGrowth: Int
    @ObservedObject var plantData: PlantData
    @Binding var isPresented: Bool
    @Binding var dormancySelection: String
    @Binding var defaultdormancy: Bool
    @Binding var potSizeInput_num1: String
    @Binding var potSizeInput_num2: String
    @Binding var potSizeInput_unit: String
    @Binding var account: String
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pot.date, ascending: true)],
        animation: .default)
    private var pot: FetchedResults<Pot>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Plant")) {
                    TextField("Enter plant name", text: $newPlantName)
                    Stepper(value: $defaultIntervalWatering, in: 1...365, label: {
                        Text("Default watering interval: \(defaultIntervalWatering) days")
                    })
                    Stepper(value: $defaultIntervalFertilizingDormancy, in: 1...365, label: {
                        Text("Default fertilizing interval for dormancy: \(defaultIntervalFertilizingDormancy) days")
                    })
                    Stepper(value: $defaultIntervalFertilizingActiveGrowth, in: 1...365, label: {
                        Text("Default fertilizing interval for ActiveGrowth: \(defaultIntervalFertilizingActiveGrowth) days")
                    })
                    Picker("Dormancy or ActiveGrowth", selection: $dormancySelection) {
                        Text("Dormancy").tag("Dormancy")
                        Text("ActiveGrowth").tag("ActiveGrowth")
                    }
                    VStack(alignment: .leading){
                        Text("Potsize (optional)")
                            .multilineTextAlignment(.leading)
                        HStack{
                            TextField("00", text: $potSizeInput_num1)
                                .keyboardType(.numberPad)
                                .frame(width: 50)
                                .multilineTextAlignment(.trailing)
                            Text(".")
                            TextField("00", text: $potSizeInput_num2)
                                .keyboardType(.numberPad)
                                .frame(width: 100)
                            Picker("Unit", selection: $potSizeInput_unit) {
                                Text("cm").tag("cm")
                                Text("L").tag("L")
                                Text("Inch").tag("Inch")
                                Text("Gallon").tag("Gallon")
                            }
                            .multilineTextAlignment(.trailing)
                        }
                    }
                }
                .listRowBackground(
                    Image("23")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.95)
                )
                
                Text("Potsize requires both an integer and a decimal value.")
                    .listRowBackground(
                        Image("23")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.95)
                    )
                            
                Section {
                    Button("Save") {
                        addNewName(name: newPlantName)
                        
                        if !potSizeInput_num1.isEmpty && !potSizeInput_num2.isEmpty{
                            
                            addPotItemToDataList(forName: newPlantName, potsize: String(potSizeInput_num1 + "." + potSizeInput_num2), potunit: potSizeInput_unit, andDate: Date())

                        }
                        
                        savePlant()
                        plantData.savePlants()
                    }
                    .disabled(newPlantName.isEmpty || (!potSizeInput_num1.isEmpty && potSizeInput_num2.isEmpty) || (potSizeInput_num1.isEmpty && !potSizeInput_num2.isEmpty) || (!potSizeInput_num1.allSatisfy { $0.isNumber } || !potSizeInput_num2.allSatisfy { $0.isNumber } ))

                }
                .listRowBackground(
                    Image("23")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.95)
                )

            }
            .scrollContentBackground(.hidden)
            .background {
                Image("33")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle("Add Plant")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Plant with the same name already exists."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear() {
            newPlantName = ""
        }
    }
    
    private func savePlant() {
        guard !newPlantName.isEmpty else {
            return
        }
        
        guard !plantData.plants.contains(where: { $0.plantType == newPlantName }) else {
            showAlert = true
            return
        }
        
        if dormancySelection == "Dormancy" {
                defaultdormancy = true
        } else {
            defaultdormancy = false
        }
        
        var newPlant = Plant(plantType: newPlantName,
                             lastUpdatedWatering: nil,
                             lastUpdatedFertilizingDormancy: nil,
                             lastUpdatedFertilizingActiveGrowth: nil,
                             intervalWatering: TimeInterval(defaultIntervalWatering) * 24 * 60 * 60,
                             defaultintervalWatering: TimeInterval(defaultIntervalWatering) * 24 * 60 * 60,
                             intervalFertilizingDormancy: TimeInterval(defaultIntervalFertilizingDormancy) * 24 * 60 * 60,
                             defaultintervalFertilizingDormancy: TimeInterval(defaultIntervalFertilizingDormancy) * 24 * 60 * 60,
                             intervalFertilizingActiveGrowth: TimeInterval(defaultIntervalFertilizingActiveGrowth) * 24 * 60 * 60,
                             defaultintervalFertilizingActiveGrowth: TimeInterval(defaultIntervalFertilizingActiveGrowth) * 24 * 60 * 60,
                             Info: ["","",""],
                             dormancy:defaultdormancy,
                             potsize_num: nil,
                             potsize_unit: nil
        )
        if !potSizeInput_num1.isEmpty {
            newPlant.potsize_num = String(potSizeInput_num1 + "." + potSizeInput_num2)
            newPlant.potsize_unit = potSizeInput_unit
        }
        plantData.plants.append(newPlant)
        isPresented = false
    }
}
