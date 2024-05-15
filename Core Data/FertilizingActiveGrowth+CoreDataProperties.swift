import Foundation
import CoreData


extension FertilizingActiveGrowth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FertilizingActiveGrowth> {
        return NSFetchRequest<FertilizingActiveGrowth>(entityName: "FertilizingActiveGrowth")
    }

    @NSManaged public var date: Date?
    @NSManaged public var lazy: Bool
    @NSManaged public var name: Name?

}

extension FertilizingActiveGrowth : Identifiable {

}
