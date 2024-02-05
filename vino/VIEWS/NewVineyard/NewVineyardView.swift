//
//  NewVineyardView.swift
//  vino
//
//  Created by Jon Grimes on 1/5/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct NewVineyardView: View {
    @ObservedObject var model: Model
    @State var vineyardName = ""
    
    init(model: Model) {
        self.model = model
    }
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("New Vineyard")
            .font(.custom("DMSerifDisplay-Regular", size: 30))
        Form {
            VStack {
                //Vineyard Name
                HStack {
                    Text("Vineyard Name")
                        .font(.custom("DMSerifDisplay-Regular", size: 20))
                    TextField("Vineyard Name", text: $vineyardName)
                        .multilineTextAlignment(.trailing)
                }
                .padding([.leading, .trailing])
                //Vineyard URL (Optional)
                HStack {
                    Text("Vineyard URL")
                        .font(.custom("DMSerifDisplay-Regular", size: 20))
                    TextField("(optional)", text: $vineyardName)
                        .multilineTextAlignment(.trailing)
                }
                .padding([.leading, .trailing])
                //Vineyard Location
                //MARK: MAP - Figure out dropping pins
                //Use map to drop pin to get CLLocation coordinates
                Map()
                    .frame(width: 350, height: 400)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .mapStyle(.standard(elevation: .realistic))
                    .padding()
                
                //Submit Button
                Button("Add New Vineyard", action: {
                    dismiss()
                })
                .font(.custom("DMSerifDisplay-Regular", size: 25))
                .padding()
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NewVineyardView(model: Model())
}
