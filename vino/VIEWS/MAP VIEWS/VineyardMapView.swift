//
//  VineyardMapView.swift
//  vino
//
//  Created by Jon Grimes on 1/12/24.
//

import SwiftUI
import MapKit

struct VineyardMapView: View {
    @State var vineyard: Vineyard
    @State var mapCamera: MapCameraPosition = MapCameraPosition.automatic
    var body: some View {
        //How to zoom map out??
        Map(position: $mapCamera) {
            Marker(vineyard.name, image: "mappin", coordinate: CLLocationCoordinate2D(latitude: vineyard.location.coordinate.latitude, longitude: vineyard.location.coordinate.longitude))
        }
        .mapStyle(.imagery)
        .frame(width: 350, height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .onAppear {
            //load Map Camera position at runtime
            mapCamera = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: vineyard.location.coordinate.latitude, longitude: vineyard.location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
        }
    }
}

#Preview {
    VineyardMapView(vineyard: Vineyard("Jordan Winery & Vineyard",
                                       CLLocation(
                                        latitude: 38.65617 , longitude:
                                            -122.83946),
                                       "https://www.jordanwinery.com/"))
}
