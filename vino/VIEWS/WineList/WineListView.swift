//
//  WineListView.swift
//  vino
//
//  Created by Jon Grimes on 12/19/23.
//

import SwiftUI
import CoreLocation

struct WineListView: View {
    var wine: Wine

    var body: some View {
        VStack(alignment: .leading, spacing: 3, content: {
            Text(wine.type)
                .font(.custom("DMSerifDisplay-Regular", size: 30))
                .foregroundStyle(Color.black)
            HStack {
                Text(wine.type)
                    .lineLimit(1)
                Text("-")
                Text(wine.vineyard.name)
                    .lineLimit(1)
                Text("-")
                Text(wine.vintage)
            }
            .font(.custom("Oswald-Regular", size: 15))
            .foregroundStyle(Color(.gray))
            
        })
    }
}

#Preview {
    WineListView(wine: Wine("Cabernet Sauvignon", "2019", Vineyard("Jordan", CLLocation(latitude: 38.6562, longitude: 122.8438), "https://www.jordanwinery.com/")))
}
