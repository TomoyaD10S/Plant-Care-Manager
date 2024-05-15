import Foundation
import CoreData


extension Pot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pot> {
        return NSFetchRequest<Pot>(entityName: "Pot")
    }

    @NSManaged public var potsize: String?
    @NSManaged public var potunit: String?
    @NSManaged public var date: Date?
    @NSManaged public var name: Name?

}

extension Pot : Identifiable {

}
