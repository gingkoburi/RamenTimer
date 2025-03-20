//
//  CreditView.swift
//  Ramentimer
//
//  Created by sunwook Kwon on 2025/03/20.
//

import Foundation
import SwiftUI

struct CreditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
//            Text("Credits")
//                .font(.largeTitle)
//                .bold()
//                .padding()
            
            Text("Ramentimer Version 1.1")
                .font(.largeTitle)
                .padding()

            Text("Gingkoburi Corp. © 2025")
                .font(.title)
    
            Text("gingkoburi@gmail.com")
                .font(.title)
                .padding(.top, 5)

            Spacer()

            Button("Close") {
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
