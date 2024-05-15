import Foundation
import CoreData


extension FertilizingDormancy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FertilizingDormancy> {
        return NSFetchRequest<FertilizingDormancy>(entityName: "FertilizingDormancy")
    }

    @NSManaged public var date: Date?
    @NSManaged public var lazy: Bool
    @NSManaged public var name: Name?

}

extension FertilizingDormancy : Identifiable {

}
