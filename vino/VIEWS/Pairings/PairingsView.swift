//
//  PairingsView.swift
//  vino
//
//  Created by Jon Grimes on 1/14/24.
//

import SwiftUI

struct PairingsView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($model.pairings.indices, id: \.self) { index in
                    NavigationLink(destination: {
                        PairingInfoView(pairing: $model.pairings[index], model: model)
                    }, label: {
                        PairingListView(pairing: model.pairings[index])
                    })
                }
            }
        }
    }
}
