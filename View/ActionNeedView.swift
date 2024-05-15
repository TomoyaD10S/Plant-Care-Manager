import SwiftUI

    
struct ActionNeedView: View {
    @ObservedObject var plantData: PlantData
    @State private var showingAddPlantSheet = false
    @State private var newPlantName = ""
    
    public var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List(plantData.plants.filter { plant in
                let currentTime = Date()
                var watering = false
                var fertilizing = false
                var snooze_check = true
                
                if let lastUpdatedWatering = plant.lastUpdatedWatering {
                    let elapsedTimeWatering = currentTime.timeIntervalSince(lastUpdatedWatering)
                    if elapsedTimeWatering >= plant.intervalWatering{
                        watering = true
                    }
                }
                if plant.dormancy == true {
                    if let lastUpdatedFertilizingDormancy = plant.lastUpdatedFertilizingDormancy {
                        let elapsedTimeFertilizingDormancy = currentTime.timeIntervalSince(lastUpdatedFertilizingDormancy)
                        if elapsedTimeFertilizingDormancy >= plant.intervalFertilizingDormancy{
                            fertilizing = true
                        }
                    }
                } else {
                    if let lastUpdatedFertilizingActiveGrowth = plant.lastUpdatedFertilizingActiveGrowth {
                        let elapsedTimeFertilizingActiveGrowth = currentTime.timeIntervalSince(lastUpdatedFertilizingActiveGrowth)
                        if elapsedTimeFertilizingActiveGrowth >= plant.intervalFertilizingActiveGrowth{
                            fertilizing = true
                        }
                    }
                    
                }
                if let snooze = plant.snooze {
                    let elapsedTime  = currentTime.timeIntervalSince(snooze)
                    if elapsedTime < 1*24*60*60 {
                        snooze_check = false
                    }
                }
                return (watering || fertilizing) && snooze_check
            }) { plant in
                PlantStatusView(name: plant.plantType, plantData: self.plantData, isDormancy:plant.dormancy, isActionNeedView: true)
                    .listRowSeparatorTint(.black)
                
            }
            .background{
                Color(red: 217/255, green: 231/255, blue: 223/255)
                    .edgesIgnoringSafeArea(.all)
            }
            .scrollContentBackground(.hidden)
            //.background(Color.clear)
            .navigationTitle("Action Needed")
            
        }
        .onAppear {
            plantData.savePlants()
        }
        .onDisappear {
            plantData.savePlants()
        }
    }
}
