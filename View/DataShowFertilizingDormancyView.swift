import SwiftUI
import CoreData

struct DataShowFertilizingDormancyView: View {
    @ObservedObject var plantData: PlantData
    @Environment(\.managedObjectContext) private var viewContext
    
    let name: String
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FertilizingDormancy.date, ascending: true)],
        animation: .default)
    private var fertilizingDormancydata: FetchedResults<FertilizingDormancy>
    
    private var filteredFertilizingDormancyData: [FertilizingDormancy] {
        guard let nameEntity = fetchName(withName: name) else {
            return []
        }
        return fertilizingDormancydata.filter { $0.name == nameEntity }
    }
    
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var selectedItem: FertilizingDormancy?
    
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
                    ForEach(filteredFertilizingDormancyData.reversed(), id: \.self) { event in
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
                            print(Array(fertilizingDormancydata))
                            
                            if let latestFertilizingDormancy = fertilizingDormancydata.last {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].lastUpdatedFertilizingDormancy = latestFertilizingDormancy.date
                                }
                            } else {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].lastUpdatedFertilizingDormancy = nil
                                }
                            }
                            plantData.savePlants()
                            
                            let newInterval = calculateFertilizingDormancyAverageDuration(dataItems: Array(fertilizingDormancydata))

                            if newInterval != -1.0 {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].intervalFertilizingDormancy = newInterval
                                    print(plantData.plants[index].intervalFertilizingDormancy)
                                    
                                }
                            } else {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].intervalFertilizingDormancy = plantData.plants[index].defaultintervalFertilizingDormancy
                                }
                            }
                            
                            plantData.savePlants()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Fertilizing Dormancy")
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
        selectedItem = fertilizingDormancydata[offsets.first!]
    }
    
    private func deleteItem(_ item: FertilizingDormancy) {
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
