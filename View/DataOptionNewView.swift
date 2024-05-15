import SwiftUI

struct ID: Identifiable {
    var id = UUID()
    var name: String
}

struct DataOptionNewView: View {
    @State private var ids = [
        ID(name: "Edit Name"),
        ID(name: "Show Data")
    ]
    
    @ObservedObject var plantData: PlantData
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var text: String = ""
    @State private var navigationIsActive = false
    @State private var editname_navigationIsActive = false
    @State private var isdelete = false
    @Binding var isDataOptionViewPresented: Bool
    @Binding var name: String
    let plantType: String
    let Account: String
    
    private func destinationView(for item: ID) -> some View {
        switch item.name {
        case "Edit Name":
            return AnyView(EditNameView(plantData: plantData, name: $name, Account: Account, prePlantName: plantType))
        case "Show Data":
            return AnyView(ChooseDataView(plantData: plantData, Account: Account, name: plantType))
        default:
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(ids) { ele in
                    NavigationLink(destination: destinationView(for: ele)) {
                        Text(ele.name)
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .listRowBackground(Color.white.opacity(0))
                }
                .listStyle(PlainListStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                Button("Delete \(plantType)") {
                    isdelete = true
                }
                .foregroundColor(.red)
                .padding(.bottom, 10)
                .alert(isPresented: $isdelete) {
                    Alert(
                        title: Text("Delete Confirmation"),
                        message: Text("Are you sure you want to delete \(plantType)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            plantData.deletePlant(forType: plantType)
                            plantData.savePlants()
                        },
                        secondaryButton: .cancel()
                    )
                }
                
            }
            .navigationTitle(plantType)
            .navigationBarItems(trailing:
                                    Button(action: {
                isDataOptionViewPresented = false
                
            }) {
                Text("Back")
            }
            )
            .background{
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}



