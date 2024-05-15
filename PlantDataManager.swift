import Foundation

class PlantDataManager {
    static let shared = PlantDataManager()
    private let userDefaults = UserDefaults.standard
    
    private let plantsKey = "SavedPlants"
    
    func savePlants(_ plants: [Plant]) {
        let encodedData = try? JSONEncoder().encode(plants)
        userDefaults.set(encodedData, forKey: plantsKey)
    }
    
    func loadPlants() -> [Plant] {
        if let savedData = userDefaults.data(forKey: plantsKey),
           let decodedPlants = try? JSONDecoder().decode([Plant].self, from: savedData) {
            return decodedPlants
        }
        return []
    }
}
