import SwiftUI

struct InfoView: View {
    @ObservedObject var plantData: PlantData
    @State private var isEditInfo1 = false
    @State private var isEditInfo2 = false
    @State private var isEditInfo3 = false
    @Binding var isInfoView: Bool
    
    let name: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack{
                        
                        Button("Edit Info1") {
                            isEditInfo1 = true
                        }
                        .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                        .padding(.bottom, 10)
                        .navigationDestination(
                            isPresented:$isEditInfo1){
                                EditInfoView(plantData:plantData, isEditInfoView: $isEditInfo1, name:name, idx: 0)
                            }
                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                            Text(plantData.plants[index].Info[0])
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        } else {
                            Text("Information doesn't exist")
                        }
                        
                        Button("Edit Info2") {
                            isEditInfo2 = true
                        }
                        .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                        .padding(.bottom, 10)
                        .navigationDestination(
                            isPresented:$isEditInfo2){
                                EditInfoView(plantData:plantData,  isEditInfoView: $isEditInfo2, name:name, idx: 1)
                            }
                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                            Text(plantData.plants[index].Info[1])
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        } else {
                            Text("Information doesn't exist")
                        }
                        
                        Button("Edit Info3") {
                            isEditInfo3 = true
                        }
                        .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                        .padding(.bottom, 10)
                        .navigationDestination(
                            isPresented:$isEditInfo3){
                                EditInfoView(plantData:plantData,  isEditInfoView: $isEditInfo3, name:name, idx: 2)
                            }
                        if let index = plantData.plants.firstIndex(where: { $0.plantType == name }) {
                            Text(plantData.plants[index].Info[2])
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        } else {
                            Text("Information doesn't exist")
                        }
                    }
                    .navigationBarItems(trailing:
                                            Button(action: {
                        isInfoView = false
                    }) {
                        Text("Back")
                            .foregroundColor(Color(red: 18/255, green: 83/255, blue: 20/255))
                    }
                    )
                }
            }
        }
    }
}
