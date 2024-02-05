//
//  PairingsView.swift
//  vino
//
//  Created by Jon Grimes on 1/14/24.
//

import SwiftUI

struct PairingsView: View {
    @EnvironmentObject var model: Model
    @State var topWines: [Wine] = []
    @State var pairings: [[Pairing]] = []
    
    var body: some View {
        ScrollView {
            Text("Pairings For You")
                .font(.custom("Oswald-Regular", size: 30))
            VStack {
                ForEach(topWines.indices, id: \.self) { index in
                    Text("Because you like \(topWines[index].type)")
                    //Horizontal Scroll of PairingCards for pairings that include the wine type in their specific wines
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(pairings[index], id: \.self) { pairing in
                                PairingCard(pairing: pairing)
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            topWines = findMostFrequentElements(model.activeUser.wines)
            for wine in topWines {
                pairings.append(pairings(for: wine.type))
            }
        }
    }
    
     func findMostFrequentElements<T: Hashable>(_ array: [T]) -> [T] {
        var counts = [T: Int]()
        
        // Count occurrences of each element in the array
        for element in array {
            counts[element, default: 0] += 1
        }
        
        // Sort the dictionary by counts in descending order
        let sortedCounts = counts.sorted { $0.value > $1.value }
        
        // Select the top 4 elements
        let topFour = Array(sortedCounts.prefix(4)).map { $0.key }
        
        return topFour
    }
    
    func pairings(for wine: String) -> [Pairing] {
        var pairings: [Pairing] = []
        for pairing in model.pairings {
            if pairing.specificWines.contains(where: {$0 == wine}) {
                pairings.append(pairing)
            }
        }
        return pairings
    }
}
