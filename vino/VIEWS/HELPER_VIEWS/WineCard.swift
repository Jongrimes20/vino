//
//  WineCard.swift
//  vino
//
//  Created by Jon Grimes on 1/31/24.
//

import SwiftUI
import CoreLocation

struct WineCard: View {
    @State var wine: Wine
    @State var image: UIImage = UIImage(systemName: "wineglass")!
    
    let model = Model()
    
    var body: some View {
        ZStack {
            //need to provide default value if image does not exist
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 400)
            //Text Overlay
            VStack {
                Spacer()
                Color(uiColor: .lightGray).opacity(0.75)
                    .frame(height: 125)
            }
            Text(wine.type)
                .font(.custom("Oswald-Regular", size: 25))
                .lineLimit(1)
                .padding(.top, 200)
                
        }
        .frame(width: 250, height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .onAppear {
            //solve for image
            if wine.images.count > 0 {
                image = wine.images[0]
            }
            else {
                //red
                if model.redWines.contains(where: { $0 == wine.type }) {
                    image = UIImage(named: "redwine")!
                }
                //white
                if model.whiteWines.contains(where: { $0 == wine.type }) {
                    image = UIImage(named: "whitewine")!
                }
                //champagne
                if wine.type == "Champagne" {
                    image = UIImage(named: "champagne")!
                }
                //rose
                if wine.type == "Rosé" {
                    image = UIImage(named: "rose")!
                }
            }
        }
    }
}

struct WineCard_Previews: PreviewProvider {
    static var previews: some View {
        @State var wine = Wine("Cabernet Sauvignon",
                               "2018",
                               Vineyard("Jordan Winery & Vineyard",
                                        CLLocation(
                                          latitude: CLLocationDegrees(floatLiteral: 38.6562),
                                          longitude: CLLocationDegrees(floatLiteral: -122.8438)),
                                        "https://www.jordanwinery.com/"),
                               [UIImage(named: "2018-alexander-valley-jordan-cabernet-sauvignon")!]
                              )
        WineCard(wine: wine)
    }
}
