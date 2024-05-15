//
//  TermsAndConditionsView.swift
//  plants-app-serverless
//
//  Created by 町田禎弥 on 2024/05/13.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15){
                    Text("TERMS AND CONDITIONS")
                        .font(.system(size: 25, weight: .bold))
                    Spacer().frame(height: 10)
                    
                    Text("Create your own TERMS AND CONDITIONS")
                    Spacer().frame(height: 20)
                    
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
