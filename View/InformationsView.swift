import SwiftUI


struct InformationsView: View {
    @State private var ids = [
        ID(name: "User's Manual"),
        ID(name: "Terms and Conditions")
    ]
    
    
    @State private var isInformationsView = false

    
    private func destinationView(for item: ID) -> some View {
        switch item.name {
        case "User's Manual":
            return AnyView(UserManualView())
        case "Terms and Conditions":
            return AnyView(TermsAndConditionsView())
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
                
            }
            .navigationTitle("Informations")

            .background{
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

