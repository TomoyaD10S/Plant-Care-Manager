import SwiftUI

struct PlantView: View {
    let id = UUID()
    let name: String
    @State private var isWatered: Bool = false
    @State private var isFertilized: Bool = false
    
    var body: some View {
        HStack() {
            VStack {
                Text(name)
                    .font(.headline)
                Text(isWatered ? "Watered" : "Not Watered")
                    .foregroundColor(isWatered ? .green : .red)
                Text(isFertilized ? "Fertilized" : "Not Fertilized")
                    .foregroundColor(isFertilized ? .green : .brown)
            }
            Spacer()
            Button(action: {
                isWatered.toggle()
            }) {
                Image(systemName: "drop.fill")
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle()) // Apply borderless style
            
            Button(action: {
                isFertilized.toggle()
            }) {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
            }
            .buttonStyle(BorderlessButtonStyle()) // Apply borderless style
        }
        .padding()
    }
}

struct PlantListView: View {
    @State var plants: [PlantView] = [
        PlantView(name: "Plant 1"),
        PlantView(name: "Plant 2"),
        PlantView(name: "Plant 3")
    ]
    
    var body: some View {
        NavigationView {
            List(plants.indices, id: \.self) { index in
                plants[index]
            }
            .navigationTitle("Plant Tracker")
        }
    }
}
