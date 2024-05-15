import SwiftUI

struct PlantStatusListView: View {
    @ObservedObject var plantData: PlantData
    @State private var showingAddPlantSheet = false
    @State private var newPlantName = ""
    @State private var currentDate = Date()
    @State private var defaultIntervalWatering = 7
    @State private var defaultIntervalFertilizingDormancy = 30
    @State private var defaultIntervalFertilizingActiveGrowth = 30
    @State private var defaultdormancy = false
    @State private var dormancySelection: String = "Dormancy"
    @State private var Podsize_num1: String = ""
    @State private var Podsize_num2: String = ""
    @State private var Podsize_unit: String = "cm"
    @State private var account: String = "Rebecca"
    @State private var searchword = ""
    @Environment(\.colorScheme) var colorScheme
    
    var filteredPlants: [Plant] {
        if searchword.isEmpty {
            return plantData.plants
        } else {
            let lowercaseSearchWord = searchword.lowercased()
            return plantData.plants.filter { $0.plantType.lowercased().hasPrefix(lowercaseSearchWord) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 217/255, green: 231/255, blue: 223/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    TextField("Search your plants", text: $searchword)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding()
                    
                    List {
                        ForEach(filteredPlants) { plant in
                            PlantStatusView(name: plant.plantType, plantData: self.plantData, isDormancy: plant.dormancy)
                                .listRowSeparatorTint(.black)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    
                    .navigationTitle("Plant List")
    
                    .navigationBarItems(
                        trailing: Button(action: {
                            Podsize_num1 = ""
                            Podsize_num2 = ""
                            showingAddPlantSheet = true
                        }) {
                            Image(systemName: "plus.app")
                                .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                                .font(.system(size: 30, weight: .bold))
                            
                        }
                    )
                }
            }
            .sheet(isPresented: $showingAddPlantSheet) {
                AddPlantView(newPlantName: $newPlantName, defaultIntervalWatering: $defaultIntervalWatering, defaultIntervalFertilizingDormancy: $defaultIntervalFertilizingDormancy, defaultIntervalFertilizingActiveGrowth: $defaultIntervalFertilizingActiveGrowth, plantData: plantData, isPresented: $showingAddPlantSheet, dormancySelection: $dormancySelection, defaultdormancy: $defaultdormancy, potSizeInput_num1: $Podsize_num1, potSizeInput_num2: $Podsize_num2, potSizeInput_unit:$Podsize_unit, account:$account)
            }
            .onAppear {
                plantData.savePlants()

            }
            .onDisappear {
                plantData.savePlants()
            }
        }
    }
}
