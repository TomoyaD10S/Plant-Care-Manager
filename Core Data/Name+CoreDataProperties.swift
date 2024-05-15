import Foundation
import CoreData


extension Name {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Name> {
        return NSFetchRequest<Name>(entityName: "Name")
    }

    @NSManaged public var name: String?
    @NSManaged public var pot: NSSet?
    @NSManaged public var watering: NSSet?
    @NSManaged public var fertilizingActiveGrowth: NSSet?
    @NSManaged public var fertilizingDormancy: NSSet?

}

// MARK: Generated accessors for pot
extension Name {

    @objc(addPotObject:)
    @NSManaged public func addToPot(_ value: Pot)

    @objc(removePotObject:)
    @NSManaged public func removeFromPot(_ value: Pot)

    @objc(addPot:)
    @NSManaged public func addToPot(_ values: NSSet)

    @objc(removePot:)
    @NSManaged public func removeFromPot(_ values: NSSet)

}

// MARK: Generated accessors for watering
extension Name {

    @objc(addWateringObject:)
    @NSManaged public func addToWatering(_ value: Watering)

    @objc(removeWateringObject:)
    @NSManaged public func removeFromWatering(_ value: Watering)

    @objc(addWatering:)
    @NSManaged public func addToWatering(_ values: NSSet)

    @objc(removeWatering:)
    @NSManaged public func removeFromWatering(_ values: NSSet)

}

// MARK: Generated accessors for fertilizingActiveGrowth
extension Name {

    @objc(addFertilizingActiveGrowthObject:)
    @NSManaged public func addToFertilizingActiveGrowth(_ value: FertilizingActiveGrowth)

    @objc(removeFertilizingActiveGrowthObject:)
    @NSManaged public func removeFromFertilizingActiveGrowth(_ value: FertilizingActiveGrowth)

    @objc(addFertilizingActiveGrowth:)
    @NSManaged public func addToFertilizingActiveGrowth(_ values: NSSet)

    @objc(removeFertilizingActiveGrowth:)
    @NSManaged public func removeFromFertilizingActiveGrowth(_ values: NSSet)

}

// MARK: Generated accessors for fertilizingDormancy
extension Name {

    @objc(addFertilizingDormancyObject:)
    @NSManaged public func addToFertilizingDormancy(_ value: FertilizingDormancy)

    @objc(removeFertilizingDormancyObject:)
    @NSManaged public func removeFromFertilizingDormancy(_ value: FertilizingDormancy)

    @objc(addFertilizingDormancy:)
    @NSManaged public func addToFertilizingDormancy(_ values: NSSet)

    @objc(removeFertilizingDormancy:)
    @NSManaged public func removeFromFertilizingDormancy(_ values: NSSet)

}

extension Name : Identifiable {

}
