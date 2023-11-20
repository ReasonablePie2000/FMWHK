//
//  MapView.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    var delta: Double
    
    @State private var region = MKCoordinateRegion()
    
    struct MapAnnotation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    @State private var annotations = [MapAnnotation]()
    
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: annotations,
            annotationContent: { item in
                MapMarker(coordinate: item.coordinate)
            })
        .onAppear {
            setRegion(coordinate)
            annotations.append(MapAnnotation(coordinate: coordinate))
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 22.37407, longitude: 113.99123), delta: 0.003)

    }
}

