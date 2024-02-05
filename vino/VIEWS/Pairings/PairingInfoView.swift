//
//  PairingInfoView.swift
//  vino
//
//  Created by Jon Grimes on 1/31/24.
//

import SwiftUI
import CoreLocation

struct PairingInfoView: View {
    @Binding var pairing: Pairing
    @ObservedObject var model: Model
    
    @State var wines: [Wine] = []
    
    var body: some View {
        ScrollView {
            VStack {
                //Title
                Text(pairing.title)
                    .font(.custom("Oswald-Regular", size: 30))
                    .multilineTextAlignment(.center)
                    .lineLimit(10)
                    .frame(height: 100)
                    .padding([.leading, .trailing])
                
                //Images
                HorizontalImageScrollView(images: $pairing.images, recordType: "Pairing", recordID: pairing.recordID)
                
                //Wines It goes well with
                Group {
                    Text("Wine Pairings")
                        .font(.custom("Oswald-Regular", size: 30))
                        .padding()
                    
                    //still vertical
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(wines, id: \.self) { wine in
                                WineCard(wine: wine)
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
                
                //Recipe
                Group {
                    Text("Recipe")
                        .font(.custom("Oswald-Regular", size: 30))
                        .padding()
                    Text(pairing.recipe)
                        .font(.custom("Oswald-Regular", size: 20))
                        .multilineTextAlignment(.center)
                }
                
            }
            .padding()
        }
        .onAppear {
            wines = winesFromList()
        }
    }
    
    private func winesFromList() -> [Wine] {
        var wines = [Wine]()
        
        for wine in pairing.specificWines {
            /**
             if the user has added a wine to their personal collection
             - we add that wine so we can use their photos
             */
            if model.activeUser.wines.contains(where: {$0.type == wine}) {
                wines.append(model.activeUser.wines.first(where: {$0.type == wine})!)
            }
            //create empty wine object for wine card to decide the photo
            else {
                let dummyWine = Wine(wine, "", Vineyard())
                wines.append(dummyWine)
            }
        }
        
        return wines
    }
}
