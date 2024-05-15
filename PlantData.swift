import SwiftUI

class PlantData: ObservableObject {
    static let shared = PlantData()
    @Published var plants: [Plant]
    
    init() {
        plants = PlantDataManager.shared.loadPlants()
    }
    
    func savePlants() {
        PlantDataManager.shared.savePlants(plants)
    }
    
    func deletePlant(forType plantType: String) {
        if let index = plants.firstIndex(where: { $0.plantType == plantType }) {
            plants.remove(at: index)
        }
    }
    
    func calculateBarWatering(forType plantType: String) -> (color: Color, widthFraction: CGFloat) {
        guard let plant = plants.first(where: { $0.plantType == plantType }) else {
            return (.clear, 2)
        }
        
        if let lastUpdatedWatering = plant.lastUpdatedWatering {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(lastUpdatedWatering)
            
            var color: Color
            var widthFraction: CGFloat
            
            widthFraction = CGFloat(plant.intervalWatering - elapsedTime) / CGFloat(plant.intervalWatering)
            if widthFraction <= 0.15 { // if more than six days have passed
                color = Color(red: 217/255, green: 231/255, blue: 223/255)
            } else if widthFraction <= 0.5 { // if more than four days have passed
                color = Color(red: 90/255, green: 160/255, blue: 111/255)
            } else {
                color = Color(red: 18/255, green: 83/255, blue: 20/255)
            }
            
            widthFraction = CGFloat(plant.intervalWatering - elapsedTime) / CGFloat(plant.intervalWatering)
            return (color, widthFraction)
        } else {
            return (.gray, 2)
        }
    }
    
    
    func calculateBarFertilizingDormancy(forType plantType: String) -> (color: Color, widthFraction: CGFloat) {
        guard let plant = plants.first(where: { $0.plantType == plantType }) else {
            return (.clear, 2)
        }
        
        if let lastUpdatedFertilizingDormancy = plant.lastUpdatedFertilizingDormancy {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(lastUpdatedFertilizingDormancy)
            
            var color: Color
            var widthFraction: CGFloat
            
            widthFraction = CGFloat(plant.intervalFertilizingDormancy - elapsedTime) / CGFloat(plant.intervalFertilizingDormancy)
            
            if widthFraction <= 0.15 { // if more than six days have passed
                color = Color(red: 217/255, green: 231/255, blue: 223/255)
            } else if widthFraction <= 0.5 { // if more than four days have passed
                color = Color(red: 90/255, green: 160/255, blue: 111/255)
            } else {
                color = Color(red: 18/255, green: 83/255, blue: 20/255)
            }
            
            return (color, widthFraction)
        } else {
            return (.gray, 2)
        }
    }
    
    
    func calculateBarFertilizingActiveGrowth(forType plantType: String) -> (color: Color, widthFraction: CGFloat) {
        guard let plant = plants.first(where: { $0.plantType == plantType }) else {
            return (.clear, 2)
        }
        
        if let lastUpdatedFertilizingActiveGrowth = plant.lastUpdatedFertilizingActiveGrowth {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(lastUpdatedFertilizingActiveGrowth)
            
            var color: Color
            var widthFraction: CGFloat
            
            widthFraction = CGFloat(plant.intervalFertilizingActiveGrowth - elapsedTime) / CGFloat(plant.intervalFertilizingActiveGrowth)
            
            if widthFraction <= 0.15 { // if more than six days have passed
                color = Color(red: 217/255, green: 231/255, blue: 223/255)
            } else if widthFraction <= 0.5 { // if more than four days have passed
                color = Color(red: 90/255, green: 160/255, blue: 111/255)
            } else {
                color = Color(red: 18/255, green: 83/255, blue: 20/255)
            }
            
            return (color, widthFraction)
        } else {
            return (.gray, 2)
        }
    }
    
    func saveImage(forType plantType: String, imageData: Data?) {
        
        if let index = plants.firstIndex(where: { $0.plantType == plantType }) {
            plants[index].image = imageData
        } else {
            print("植物データが見つかりませんでした。")
        }
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(plants)
            UserDefaults.standard.set(encodedData, forKey: "plantsData")
        } catch {
            print("Error encoding plant data: \(error)")
        }
    }
}

struct Plant: Identifiable, Codable {
    var id = UUID()
    var plantType: String
    var lastUpdatedWatering: Date?
    var lastUpdatedFertilizingDormancy: Date?
    var lastUpdatedFertilizingActiveGrowth: Date?
    var intervalWatering: TimeInterval
    var defaultintervalWatering: TimeInterval
    var intervalFertilizingDormancy: TimeInterval
    var defaultintervalFertilizingDormancy: TimeInterval
    var intervalFertilizingActiveGrowth: TimeInterval
    var defaultintervalFertilizingActiveGrowth: TimeInterval
    var snooze: Date?
    var image: Data?
    var Info: [String]
    var dormancy: Bool
    var potsize_num: String?
    var potsize_unit: String?
}

