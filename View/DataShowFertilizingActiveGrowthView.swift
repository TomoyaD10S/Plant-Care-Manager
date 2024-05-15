import SwiftUI
import CoreData

 struct DataShowFertilizingActiveGrowthView: View {
     @ObservedObject var plantData: PlantData
     @Environment(\.managedObjectContext) private var viewContext
     
     let name: String
     
     @FetchRequest(
         sortDescriptors: [NSSortDescriptor(keyPath: \FertilizingActiveGrowth.date, ascending: true)],
         animation: .default)
     private var fertilizingActiveGrowthdata: FetchedResults<FertilizingActiveGrowth>
     
     private var filteredFertilizingActiveGrowthData: [FertilizingActiveGrowth] {
         guard let nameEntity = fetchName(withName: name) else {
             return []
         }
         return fertilizingActiveGrowthdata.filter { $0.name == nameEntity }
     }
     
     @State private var isEditing = false
     @State private var showAlert = false
     @State private var selectedItem: FertilizingActiveGrowth?
     
     private func formatDate(_ date: Date?) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
         dateFormatter.timeZone = TimeZone.current
         return dateFormatter.string(from: date ?? Date())
     }
     
     var body: some View {
         NavigationView {
             VStack {
                 List {
                     ForEach(filteredFertilizingActiveGrowthData.reversed(), id: \.self) { event in
                         HStack {
                             VStack(alignment: .leading) {
                                 Text("Date: \(formatDate(event.date))")
                                 Text("Lazy: \(event.lazy ? "True" : "False")")
                             }
                             Spacer()
                             if isEditing {
                                 Button(action: {
                                     showAlert = true
                                     selectedItem = event
                                 }) {
                                     Image(systemName: "trash")
                                         .foregroundColor(.red)
                                 }
                             }
                         }
                         .listRowBackground(
                             Image("23")
                                 .resizable()
                                 .scaledToFill()
                                 .opacity(0.95)
                         )
                     }
                 }
             }
             .background{
                 Image("23")
                     .resizable()
                     .edgesIgnoringSafeArea(.all)
             }
             .alert(isPresented: $showAlert) {
                 Alert(
                     title: Text(""),
                     message: Text("Are you sure you want to delete this item?"),
                     primaryButton: .destructive(Text("Delete")) {
                         if let item = selectedItem {
                             deleteItem(item)
                             print(Array(fertilizingActiveGrowthdata))
                             
                             if let latestFertilizingActiveGrowth = fertilizingActiveGrowthdata.last {
                                 if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                     plantData.plants[index].lastUpdatedFertilizingActiveGrowth = latestFertilizingActiveGrowth.date
                                 }
                             } else {
                                 if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                     plantData.plants[index].lastUpdatedFertilizingActiveGrowth = nil
                                 }
                             }
                             plantData.savePlants()
                             
                             let newInterval = calculateFertilizingActiveGrowthAverageDuration(dataItems: Array(fertilizingActiveGrowthdata))

                             if newInterval != -1.0 {
                                 if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                     plantData.plants[index].intervalFertilizingActiveGrowth = newInterval
                                     print(plantData.plants[index].intervalFertilizingActiveGrowth)
                                     
                                 }
                             } else {
                                 if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                     plantData.plants[index].intervalFertilizingActiveGrowth = plantData.plants[index].defaultintervalFertilizingActiveGrowth
                                 }
                             }
                             
                             plantData.savePlants()
                         }
                     },
                     secondaryButton: .cancel()
                 )
             }
             .navigationTitle("Fertilizing Active Growth")
             .navigationBarItems(trailing: Button(action: {
                 isEditing.toggle()
             }) {
                 Text(isEditing ? "Done" : "Edit")
             })
         }
     }
     
     private func deleteItems(offsets: IndexSet) {
         withAnimation {
             showAlert = true
         }
         selectedItem = fertilizingActiveGrowthdata[offsets.first!]
     }
     
     private func deleteItem(_ item: FertilizingActiveGrowth) {
         withAnimation {
             viewContext.delete(item)
             do {
                 try viewContext.save()
             } catch {
                 print("Error deleting item: \(error)")
             }
         }
     }
 }

