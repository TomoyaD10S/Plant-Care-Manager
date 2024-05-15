import SwiftUI


func calculateAverageDuration(dataItems: [Watering]) -> Double {
    var dataValues: [Double] = []
    
    for i in stride(from: dataItems.count - 1, to: 0, by: -1) {
        if let prevDate = dataItems[i-1].date, let currDate = dataItems[i].date {
            let diffSeconds = currDate.timeIntervalSince(prevDate)
            dataValues.append(diffSeconds)
                
            if dataValues.count >= 10 {
                break
            }
        }
    }
    
    var sumDiff: Double = 0
    var count: Int = 0
    var averageDuration: Double = -1.0
    
    for dataValue in dataValues {
        if dataValue != 0 {
            count += 1
            sumDiff += dataValue
        }
    }
    
    if count != 0 {
        averageDuration = sumDiff / Double(count)
    }
    
    return averageDuration
}

func calculateFertilizingDormancyAverageDuration(dataItems: [FertilizingDormancy]) -> Double {
    var dataValues: [Double] = []
    
    for i in stride(from: dataItems.count - 1, to: 0, by: -1) {
        if let prevDate = dataItems[i-1].date, let currDate = dataItems[i].date {
            let diffSeconds = currDate.timeIntervalSince(prevDate)
            dataValues.append(diffSeconds)
                
            if dataValues.count >= 10 {
                break
            }
        }
    }
    
    var sumDiff: Double = 0
    var count: Int = 0
    var averageDuration: Double = -1.0
    
    for dataValue in dataValues {
        if dataValue != 0 {
            count += 1
            sumDiff += dataValue
        }
    }
    
    if count != 0 {
        averageDuration = sumDiff / Double(count)
    }
    
    return averageDuration
}

func calculateFertilizingActiveGrowthAverageDuration(dataItems: [FertilizingActiveGrowth]) -> Double {
    var dataValues: [Double] = []
    
    for i in stride(from: dataItems.count - 1, to: 0, by: -1) {
        if let prevDate = dataItems[i-1].date, let currDate = dataItems[i].date {
            let diffSeconds = currDate.timeIntervalSince(prevDate)
            dataValues.append(diffSeconds)
                
            if dataValues.count >= 10 {
                break
            }
        }
    }
    
    var sumDiff: Double = 0
    var count: Int = 0
    var averageDuration: Double = -1.0
    
    for dataValue in dataValues {
        if dataValue != 0 {
            count += 1
            sumDiff += dataValue
        }
    }
    
    if count != 0 {
        averageDuration = sumDiff / Double(count)
    }
    
    return averageDuration
}
