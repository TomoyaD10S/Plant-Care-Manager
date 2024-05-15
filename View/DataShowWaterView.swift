import SwiftUI
import CoreData

struct DataShowWaterView: View {
    @ObservedObject var plantData: PlantData
    @Environment(\.managedObjectContext) private var viewContext
    
    let name: String
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Watering.date, ascending: true)],
        animation: .default)
    private var wateringdata: FetchedResults<Watering>
    
    private var filteredWateringData: [Watering] {
        guard let nameEntity = fetchName(withName: name) else {
            return []
        }
        return wateringdata.filter { $0.name == nameEntity }
    }
    
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var selectedItem: Watering?
    
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
                    ForEach(filteredWateringData.reversed(), id: \.self) { event in
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
                            print(Array(wateringdata))
                            
                            if let latestWatering = filteredWateringData.last {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].lastUpdatedWatering = latestWatering.date
                                }
                            } else {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].lastUpdatedWatering = nil
                                }
                            }
                            plantData.savePlants()
                            
                            let newInterval = calculateAverageDuration(dataItems: Array(filteredWateringData))

                            if newInterval != -1.0 {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].intervalWatering = newInterval
                                    print(plantData.plants[index].intervalWatering)
                                    
                                }
                            } else {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].intervalWatering = plantData.plants[index].defaultintervalWatering
                                }
                            }
                            
                            plantData.savePlants()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Watering")
            .navigationBarItems(trailing: Button(action: {
                isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Edit")
            })
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        offsets.forEach { index in
            let item = filteredWateringData[index]
            showAlert = true
            selectedItem = item
        }
    }
    
    private func deleteItem(_ item: Watering) {
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
