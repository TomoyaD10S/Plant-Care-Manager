import SwiftUI
import CoreData


func addNewName(name: String) {
    let context = PersistenceController.shared.container.viewContext
    
    let newName = Name(context: context)
    newName.name = name
    
    do {
        try context.save()
        print("New name '\(name)' added successfully!")
    } catch {
        print("Failed to save data: \(error)")
    }
}



func fetchName(withName name: String) -> Name? {
    let context = PersistenceController.shared.container.viewContext
    
    let fetchRequest: NSFetchRequest<Name> = Name.fetchRequest()
    let predicate = NSPredicate(format: "name == %@", name)
    fetchRequest.predicate = predicate
    
    do {
        let results = try context.fetch(fetchRequest)
        return results.first
    } catch {
        print("Failed to fetch name data: \(error)")
        return nil
    }
}

func addWateringToDataList(forName name: String, withDate date: Date, andValue lazy: Bool) {
    // 名前を取得
    guard let nameEntity = fetchName(withName: name) else {
        print("Name '\(name)' not found.")
        return
    }
    
    let context = PersistenceController.shared.container.viewContext

    let newItem = Watering(context: context)
    newItem.date = date
    newItem.lazy = lazy
    
    newItem.name = nameEntity



    do {
        try context.save()
        print("Watering added to list for name '\(nameEntity.name ?? "Unknown")' successfully!")
    } catch {
        print("Failed to save data: \(error)")
    }
}

func addFertilizingDormancyToDataList(forName name: String, withDate date: Date, andValue lazy: Bool) {

    guard let nameEntity = fetchName(withName: name) else {
        print("Name '\(name)' not found.")
        return
    }
    
    let context = PersistenceController.shared.container.viewContext

    let newItem = FertilizingDormancy(context: context)
    newItem.date = date
    newItem.lazy = lazy
    
    newItem.name = nameEntity
    
    do {
        try context.save()
        print("Item added to list successfully!")
    } catch {
        print("Failed to save data: \(error)")
    }
}

func addFertilizingActiveGrowthToDataList(forName name: String, withDate date: Date, andValue lazy: Bool) {

    guard let nameEntity = fetchName(withName: name) else {
        print("Name '\(name)' not found.")
        return
    }
    
    let context = PersistenceController.shared.container.viewContext

    let newItem = FertilizingActiveGrowth(context: context)
    newItem.date = date
    newItem.lazy = lazy
    
    newItem.name = nameEntity
    
    do {
        try context.save()
        print("Item added to list successfully!")
    } catch {
        print("Failed to save data: \(error)")
    }
}

func addPotItemToDataList(forName name: String, potsize: String, potunit: String, andDate date: Date) {

    guard let nameEntity = fetchName(withName: name) else {
        print("Name '\(name)' not found.")
        return
    }
    
    let context = PersistenceController.shared.container.viewContext

    let newItem = Pot(context: context)
    newItem.potsize = potsize
    newItem.potunit = potunit
    newItem.date = date


    newItem.name = nameEntity
    
    do {
        try context.save()
        print("Item added to second list successfully!")
    } catch {
        print("Failed to save data: \(error)")
    }
}

func updateName(name: String, newName: String) {

    guard let nameEntity = fetchName(withName: name) else {
        print("Name '\(name)' not found.")
        return
    }
    
    let context = PersistenceController.shared.container.viewContext
    
    nameEntity.name = newName
    
    do {
        try context.save()
        print("Name updated successfully!")
    } catch {
        print("Failed to update name: \(error)")
    }
}
