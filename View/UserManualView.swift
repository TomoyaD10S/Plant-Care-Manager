import SwiftUI

struct UserManualView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15){
                    Text("User's Manual")
                        .font(.system(size: 25, weight: .bold))
                    Spacer().frame(height: 10)
                    
                    Text("TABLE OF CONTENTS")
                        .font(.system(size: 20, weight: .bold))
                    Text("1. ")
                    
                    Spacer().frame(height: 10)
                    
                    Text("1. ")
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("Create your own user manual.")
                    
                    Spacer().frame(height: 10)
                    Spacer().frame(height: 10)
                    
                    
                    
                }
            }
            .padding()
            .background{
                Image("23")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

