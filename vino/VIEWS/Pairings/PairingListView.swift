//
//  PairingListView.swift
//  vino
//
//  Created by Jon Grimes on 1/31/24.
//

import SwiftUI

struct PairingListView: View {
    var pairing: Pairing

    var body: some View {
        Text(pairing.title)
            .font(.custom("DMSerifDisplay-Regular", size: 30))
            .foregroundStyle(Color.black)
    }
}
