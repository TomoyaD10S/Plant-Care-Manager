import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @ObservedObject var plantData: PlantData = PlantData()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ActionNeedView(plantData: plantData)
                .tabItem {
                    Image(systemName: "alarm.waves.left.and.right.fill")
                    Text("Action Needed")
                }
                .tag(0)
            
            PlantStatusListView(plantData: plantData)
                .tabItem {
                    Image(systemName: "book.pages.fill")
                    Text("Plant List")
                }
                .tag(1)
            InformationsView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Informations")
                }
                .tag(2)
        }
        .accentColor(Color(red: 18/255, green: 83/255, blue: 20/255))
        .onDisappear {
            plantData.savePlants()
        }
    }
}
