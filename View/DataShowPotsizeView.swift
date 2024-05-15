import SwiftUI
import CoreData

struct DataShowPotsizeView: View {
    @ObservedObject var plantData: PlantData
    @Environment(\.managedObjectContext) private var viewContext
    
    let name: String
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pot.date, ascending: true)],
        animation: .default)
    private var potdata: FetchedResults<Pot>
    
    private var filteredPotData: [Pot] {
        guard let nameEntity = fetchName(withName: name) else {
            return []
        }
        return potdata.filter { $0.name == nameEntity }
    }
    
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var selectedItem: Pot?
    
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
                    ForEach(filteredPotData.reversed(), id: \.self) { event in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Date: \(formatDate(event.date))")
                                Text("Potsize: \(event.potsize ?? "") \(event.potunit ?? "")")
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
                            print(Array(potdata))
                            
                            if let latestPot = potdata.last {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].potsize_num = latestPot.potsize
                                    plantData.plants[index].potsize_unit = latestPot.potunit
                                    
                                }
                            } else {
                                if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                                    plantData.plants[index].potsize_num = nil
                                    plantData.plants[index].potsize_unit = nil
                                }
                            }
                            plantData.savePlants()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Potsize")
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
        selectedItem = potdata[offsets.first!]
    }
    
    private func deleteItem(_ item: Pot) {
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
