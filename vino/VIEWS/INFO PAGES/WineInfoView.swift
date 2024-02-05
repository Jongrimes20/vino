//
//  WineInfoView.swift
//  vino
//
//  Created by Jon Grimes on 1/11/24.
//

import SwiftUI
import CoreLocation
import UIKit
import MapKit


struct WineInfoView: View {
    //ADD MODEL HERE
    @EnvironmentObject var model: Model
    @Binding var wine: Wine
    @State var index: Int = 0
    @State private var position: MapCameraPosition?
    @State private var scene: MKLookAroundScene?
    @State private var userNotes: String = ""
    
    
    var body: some View {
        ScrollView(content: {
            VStack {
                //WORKS PROPERLY HERE
                HorizontalImageScrollView(images: $wine.images, recordType: "Wine", recordID: wine.recordID)
                //NOTES GROUP
                Group {
                    //Apperance:
                    HStack{
                        Text("Your Notes:")
                            .font(.custom("Oswald-Bold", size: 30))
                            .padding()
                        Spacer()
                    }
                    Text(userNotes)
                        .font(.custom("Oswald-Regular", size: 15))
                        .multilineTextAlignment(.center)
                        .lineLimit(10)
                        .frame(height: 100)
                        .padding([.leading, .trailing])
                    
                }
                //VINEYARD
                Group {
                    Text("Vineyard")
                        .font(.custom("Oswald-Bold", size: 30))
                        .padding()
                    
                    //Map
                    VineyardMapView(vineyard: wine.vineyard)
                        .padding()
                    
                    // only display if location has a lookaround scene
                    if scene != nil {
                        Text("Explore \(wine.vineyard.name)")
                            .font(.custom("Oswald-Bold", size: 20))
                            .padding()
                        //Look Around Scene
                        LookAroundPreview(scene: $scene, allowsNavigation: true, badgePosition: .bottomTrailing)
                            .frame(width: 350, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    }
                }
                //Pairings
                Group {
                    Text("Pairings")
                        .font(.custom("Oswald-Bold", size: 30))
                        .padding()
                    //MARK: ADD WINE SPECIFIC PAIRINGS HERE
                }
            }
            .navigationTitle("\(wine.type), \(wine.vineyard.name), \(wine.vintage)")
        })
        .onAppear {
            userNotes = model.activeUser.wineNotes[index]
            //fetch look around scene
            Task {
                scene = try? await fetchScene(for: CLLocationCoordinate2D(latitude: wine.vineyard.location.coordinate.latitude, longitude: wine.vineyard.location.coordinate.longitude))
            }
        }
    }
    
    func extractContent(from input: String, sectionHeader: String) -> String? {
        let pattern = "\(sectionHeader):\\s*(.*?)\n*"
        
        if let range = input.range(of: pattern, options: .regularExpression) {
            return String(input[range])
                .replacingOccurrences(of: "\(sectionHeader):", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return nil
    }
    
    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
}

struct WineInfoView_Previews: PreviewProvider {
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
        WineInfoView(wine: $wine)
    }
}
