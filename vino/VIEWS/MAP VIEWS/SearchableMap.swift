//
//  SearchableMap.swift
//  vino
//
//  Created by Jon Grimes on 1/8/24.
//

import SwiftUI
import MapKit

struct SearchableMap: View {
    //State vars
    @State private var position = MapCameraPosition.automatic
    @State private var isSheetPresented: Bool = true
    @State private var searchResults = [SearchResult]()
    @State private var selectedLocation: SearchResult?
    //for creating vineyard object
    @State private var locationTitle: String = ""
    @State private var locationUrl: URL = URL(fileURLWithPath: "")
    
    //Need to add binding var to pass selected location back to new vineyard view
    @Binding var newVineyard: Vineyard
    
    //for dismiss action
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Map(position: $position, selection: $selectedLocation) {
            ForEach(searchResults) { result in
                Marker(coordinate: result.location) {
                    Image(systemName: "mappin")
                }
                .tag(result)
            }
        }
        .overlay(alignment: .bottom) {
            if selectedLocation != nil {
                //Select winery button
                HStack {
                    Spacer()
                    Button(action: {
                        // 1.) create Vineyard object from search result
                        let lat = selectedLocation?.location.animatableData.first
                        let long = selectedLocation?.location.animatableData.second
                        newVineyard = Vineyard(
                            locationTitle,
                            CLLocation(
                                latitude: lat ?? 0.0,
                                longitude: long ?? 0.0
                            ),
                            locationUrl.absoluteString
                        )
                        // 2.) dismiss view
                        dismiss()
                    }, label: {
                        //Might need to add text
                        //button styling
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                    })
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 30)
                    .padding(.bottom, 90)
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: selectedLocation) {
            isSheetPresented = selectedLocation == nil
        }
        .onChange(of: searchResults) {
            if let firstResult = searchResults.first, searchResults.count == 1 {
                selectedLocation = firstResult
            }
        }
        .sheet(isPresented: $isSheetPresented){
            //to allow searching for vineyard if user doesn't know exact location
            SheetView(searchResults: $searchResults, locationTitle: $locationTitle, locationUrl: $locationUrl )
        }
    }
    
    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
}
