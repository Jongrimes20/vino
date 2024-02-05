//
//  PairingCard.swift
//  vino
//
//  Created by Jon Grimes on 2/5/24.
//

import SwiftUI
import CloudKit

struct PairingCard: View {
    @State var pairing: Pairing
    
    var body: some View {
        ZStack {
            Image(uiImage: pairing.images[0])
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .frame(width: 200, height: 400)
            VStack {
                Spacer()
                ZStack {
                    Color.white.opacity(0.75)
                        .frame(height: 75)
                    Text(pairing.title)
                        .font(.custom("DMSerifDisplay-Regular", size: 20))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .frame(width: 200, height: 400)
    }
}

struct Pairingcard_Previews: PreviewProvider {
    static var previews: some View {
        @State var samplePairing: Pairing = Pairing(title: "Ribeye Steak",
                                              descriptiveTerms: ["Rich", "Savory"],
                                              pairedTerms: ["Ribeye Steak"],
                                              specificWines: ["Cabernet Sauvignon", "Malbec"],
                                              images: [UIImage(named: "Ribeye")!], // Assuming you have an image named "ribeye_steak_image"
                                              recipe: "Grill the ribeye steak to your desired level of doneness. Serve it with a side of roasted vegetables and mashed potatoes.",
                                              cloudID: "ribeye_pairing_123",
                                              recordID: CKRecord.ID(recordName: "ribeye_pairing_123"))
        PairingCard(pairing: samplePairing)
    }
}
