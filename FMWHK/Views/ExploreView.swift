//
//  ExploreView.swift
//  FMWHK
//
//  Created by Sam Ng on 22/11/2023.
//

import SwiftUI
import MapKit


struct ExploreView:View {
   
    
    let lyh = CLLocationCoordinate2D(
        latitude: 22.283932879705663,
        longitude: 114.13785472504728)
    let cyt = CLLocationCoordinate2D(
        latitude: 222.283257124482716, longitude: 114.13370018271972)
    let cw = CLLocationCoordinate2D(
        latitude: 22.283519579705935, longitude: 114.13471096737511)
    let cym = CLLocationCoordinate2D(
        latitude: 22.28272175206024, longitude: 114.1388863655295)
    let cyc = CLLocationCoordinate2D(
        latitude: 22.28306337971004, longitude: 114.135406794366)
    let eh = CLLocationCoordinate2D(
        latitude: 22.28254200737399, longitude: 114.13974252320251)
    let hkw = CLLocationCoordinate2D(
        latitude: 22.282939102246427, longitude: 114.13670858347567)
    let ml = CLLocationCoordinate2D(
        latitude: 22.28324557986716, longitude: 114.13774841808377)
    let lily = CLLocationCoordinate2D(
        latitude: 22.28276130735827, longitude: 114.13840809436599)
    let vc = CLLocationCoordinate2D(
        latitude: 22.28397262458758, longitude: 114.13422906552947)
    
    var body: some View {
        Map{
            Marker("LYH", systemImage: "building" ,coordinate: lyh )
                .tint(.green)
            Marker("CYT", systemImage: "building", coordinate: cyt )
                .tint(.gray)
            Marker("CW", systemImage: "building", coordinate: cw )
                .tint(.orange)
            Marker("CYM", systemImage: "building", coordinate: cym )
                .tint(.pink)
            Marker("CYC", systemImage: "building", coordinate: cyc )
                .tint(.brown)
            Marker("EH", systemImage: "building", coordinate: eh )
                .tint(.red)
            Marker("HKW", systemImage: "building", coordinate: hkw )
                .tint(.yellow)
            Marker("ML", systemImage: "book", coordinate: ml )
                .tint(.purple)
            Marker("LILY", systemImage: "building", coordinate: lily)
                .tint(.cyan)
            Marker("VC", systemImage: "building", coordinate: vc)
                .tint(.white)
        }
    }
    
}



Import SwiftUI
Import MapKit
Import Contacts

Struct ContentView: View{

@State private var searchText:String=""
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var mapItem:MKMapItem?
    @State private var placemark: CLPlacemark?

Var body: some View{
Form{
 Section(header:Text(“Location”)) {
TextField(“Where do you want to search?” , text: $searchText)
Button( action:{
 searchPlaces()
}) {
HStack(alignment : .center) {
 Spacer() ; Text(“Search”) ; Spacer()
}
} .alert(isPresented: $showAlert) {
Alert(title: Text(errorTiltle), message:
  Text(errorMessage))
}
} 
Section(hear: Text(“Result”) {
  Text(result).lineLimit(5)



