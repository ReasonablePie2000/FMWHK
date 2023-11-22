//
//  MapView.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var globalData: GlobalData
    var center: CLLocationCoordinate2D
    var span: Float
    var locations: [IdentifiableLocation]
    
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(span), longitudeDelta: CLLocationDegrees(span)))),
            annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    Image(systemName: location.pinImage)
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                        .foregroundColor(mainColor)
                        .background(mainBkColor)
                        .clipShape(Circle())
                    Text(location.text)
                        .foregroundColor(mainColor)
                        .font(.caption)
                        .bold()
                        .shadow(color: .black, radius: 1)
                }
            }
        }
    }
}

