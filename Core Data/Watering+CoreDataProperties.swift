import Foundation
import CoreData


extension Watering {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watering> {
        return NSFetchRequest<Watering>(entityName: "Watering")
    }

    @NSManaged public var date: Date?
    @NSManaged public var lazy: Bool
    @NSManaged public var name: Name?

}

extension Watering : Identifiable {

}
