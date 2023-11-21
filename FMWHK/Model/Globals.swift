//
//  Globals.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import SwiftUI

let mainBkColor = Color(hex: "101010")
let lightBkColor = Color(hex: "424242")
let mainColor = Color(hex: "4BD964")

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            self.hidden()
        }
        else{
            self
        }
    }
}

struct ViewIdentifier: Identifiable {
    let id: Int
    let name: String
    let view: AnyView
}

class showTitle: ObservableObject {
    @Published var showTitle: Bool
    
    init(_ showTitle: Bool) {
        self.showTitle = showTitle
    }
}

class titleName: ObservableObject {
    @Published var name: String
    
    init(_ name: String) {
        self.name = name
    }
}

let menuViews = [
    ViewIdentifier(id: 0, name: "Home", view: AnyView(NearbyRoutesView())),
    ViewIdentifier(id: 1, name: "Nearby Stops", view: AnyView(StopListView())),
    ViewIdentifier(id: 2, name: "Favourite", view: AnyView(FavouriteView())),
    ViewIdentifier(id: 3, name: "Reminder", view: AnyView(ReminderView())),
    ViewIdentifier(id: 4, name: "Profile", view: AnyView(ProfileView())),
]

struct ScrollingText: View {
    @State private var animate = false
    let text: Text
    let width: CGFloat

    var body: some View {
        GeometryReader { outerGeometry in
            GeometryReader { geometry in
                self.text
                    .fixedSize()
                    .offset(x: self.shouldAnimate(textWidth: geometry.size.width) ? (self.animate ? -geometry.size.width - 10 : outerGeometry.size.width + 10) : 0)
                    .onAppear {
                        if self.shouldAnimate(textWidth: geometry.size.width) {
                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                self.animate = true
                            }
                        }
                    }
            }
        }
        .frame(width: self.width, height: 50, alignment: .center) // adjust height as needed
        .mask(Rectangle())
    }

    private func shouldAnimate(textWidth: CGFloat) -> Bool {
        return textWidth > self.width
    }
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.282999, longitude: 114.137085), latitudinalMeters: 500, longitudinalMeters: 500)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        region.center.latitude = locations[0].coordinate.latitude
        region.center.longitude = locations[0].coordinate.longitude
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        if(locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse){
            locationManager.startUpdatingLocation()
        }
    }
}

