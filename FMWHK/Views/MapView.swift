//
//  MapView.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

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
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                        .background(.red)
                        .clipShape(Circle())
                    Text(location.text)
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .shadow(color: .black, radius: 2)
                }
            }
        }
    }
}

