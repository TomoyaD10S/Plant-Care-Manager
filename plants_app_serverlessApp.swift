import SwiftUI
import UIKit
import CoreData

@main

struct plants_app_CoreDataApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes =
        [.foregroundColor: UIColor(red: 18/255, green: 83/255, blue: 20/255, alpha: 1.0)]
        UINavigationBar.appearance().titleTextAttributes =
        [.foregroundColor: UIColor(red: 18/255, green: 83/255, blue: 20/255, alpha: 1.0)]
        UINavigationBar.appearance().tintColor = UIColor(red: 18/255, green: 83/255, blue: 20/255, alpha: 1.0)
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(red: 18/255, green: 83/255, blue: 20/255, alpha: 1.0)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
