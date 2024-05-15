import SwiftUI


struct ChooseDataView: View {
    @ObservedObject var plantData: PlantData
    @State private var ids = [
        ID(name: "Watering"),
        ID(name: "Fertilizing Dormancy"),
        ID(name: "Fertilizing Active Growth"),
        ID(name: "Pod Size")
    ]
    let Account: String
    let name: String
    
    var body: some View {
        VStack {
            List(ids) { ele in
                NavigationLink(destination: destinationView(for: ele)) {
                    Text(ele.name)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    //.background(Color.white)
                }
                .listRowBackground(Color.white.opacity(0))
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background{
            Image("23")
                .resizable()
                .edgesIgnoringSafeArea(.all)
        }
    }
        
    
    private func destinationView(for item: ID) -> some View {
        switch item.name {
        case "Watering":
            return AnyView(DataShowWaterView(plantData: plantData, name:name))
        case "Fertilizing Dormancy":
            return AnyView(DataShowFertilizingDormancyView(plantData: plantData, name:name))
        case "Fertilizing Active Growth":
            return AnyView(DataShowFertilizingActiveGrowthView(plantData: plantData ,name:name))
        case "Pod Size":
            return AnyView(DataShowPotsizeView(plantData: plantData, name:name))
        default:
            return AnyView(EmptyView())
        }
    }
}

