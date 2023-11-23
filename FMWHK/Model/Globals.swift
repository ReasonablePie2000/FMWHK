//
//  Globals.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import SwiftUI

let mainBkColor = Color(hex: "101010")
let lightBkColor = Color(hex: "424242")
let mainColor = Color(hex: "4BD964")


// This color hex extension is learnt from this post: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
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

class MenuBarOject: ObservableObject {
    @Published var title: String
    @Published var isShowMenuBtn: Bool
    
    init() {
        self.title = menuViews[0].name
        self.isShowMenuBtn = true
    }
    
    init(title: String, isShowMenuBtn: Bool) {
        self.title = title
        self.isShowMenuBtn = isShowMenuBtn
    }
}

class TitleName: ObservableObject {
    @Published var name: String
    
    init(_ name: String) {
        self.name = name
    }
}

let menuViews = [
    ViewIdentifier(id: 0, name: "Home", view: AnyView(NearbyRoutesView())),
    ViewIdentifier(id: 1, name: "Nearby Stops", view: AnyView(StopListView())),
    ViewIdentifier(id: 2, name: "Explore", view: AnyView(ExploreView())),
//    ViewIdentifier(id: 3, name: "Favourite", view: AnyView(FavouriteView())),
    ViewIdentifier(id: 3, name: "Share Location", view: AnyView(LocationSharingView())),
//    ViewIdentifier(id: 5, name: "Reminder", view: AnyView(ReminderView())),
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

func getTimeFrom(stringDate: String) -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter.date(from:stringDate)
}

func getMinTo(time: String) -> String? {
    guard let targetTime = getTimeFrom(stringDate: time) else {
        return nil
    }
    
    let delta = targetTime - Date()
    
    if delta == 0 {
        return "-"
    } else {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = delta >= 3600 ? [.hour, .minute] : [.minute]
        return formatter.string(from: delta) ?? "Invalid Time"
    }
}

func getMinAgo(time: String) -> String? {
    guard let targetTime = getTimeFrom(stringDate: time) else {
        return nil
    }
    
    let delta = Date() - targetTime
    
    if delta == 0 {
        return "<1"
    } else {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = delta >= 3600 ? [.hour, .minute] : [.minute]
        return formatter.string(from: delta) ?? "Invalid Time"
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

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let pinImage: String
    let text: String
}

class UserData: ObservableObject{
    @Published var isLoggedIn: Bool = false
    @Published var userID: String = ""
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userRole: String = ""
    
    func checkIfLogin() async {
        let (loginStatus, userAccount) = await CheckJWTLogin()
        
        if(loginStatus == LoginStatus.success){
            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.userID = String(userAccount!.user_id)
                self.userName = userAccount!.user_name
                self.userEmail = userAccount!.email
                self.userRole = userAccount!.role
            }
        }
    }
    
    func login(userAccount: UserAccount) async {
        DispatchQueue.main.async {
            self.isLoggedIn = true
            self.userID = String(userAccount.user_id)
            self.userName = userAccount.user_name
            self.userEmail = userAccount.email
            self.userRole = userAccount.role
        }
    }
    
    func logout() async {
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.userID = ""
            self.userName = ""
            self.userEmail = ""
            self.userRole = ""
        }
    }
}

class BuildingViewModel {
    var buildingName: String
    var buildingDesc: String
    var buildingImg: String
    var coordinate: CLLocationCoordinate2D
    
    init(buildingName: String, buildingDesc: String, buildingImg: String, coordinate: CLLocationCoordinate2D) {
        self.buildingName = buildingName
        self.buildingDesc = buildingDesc
        self.buildingImg = buildingImg
        self.coordinate = coordinate
    }
}

let globalBuildingList: [BuildingViewModel] = [
    BuildingViewModel(buildingName: "HKU Loke Yew Hall", buildingDesc: "Built in 1912, the neoclassical Main Building incorporating Loke Yew Hall is the founding building of the University of Hong Kong.", buildingImg: "LYH", coordinate: lyh),
    BuildingViewModel(buildingName: "Chi Wah Learning Commons", buildingDesc: "The 6,000 m2 Chi Wah Learning Commons (智華館) is located at the podium levels of the University’s Centennial Campus.  The facility, which spreads over three levels, is a technology-rich, shared or common space in which students, teachers and others can come together to interact, and participate in various kinds of learning activities held there.  There are a number of entrances to the Learning Commons, one of which is on the Ground (G) floor, the courtyard level, with a spiral staircase connecting levels 1 and 2 (CPD-1 and CPD-2) of the Learning Commons vertically.", buildingImg: "CWC", coordinate: cw),
]


let lyh = CLLocationCoordinate2D(
    latitude: 22.283932879705663,
    longitude: 114.13785472504728)
//    let cyt = CLLocationCoordinate2D(
//        latitude: 222.283257124482716, longitude: 114.13370018271972)
let cw = CLLocationCoordinate2D(
    latitude: 22.283519579705935, longitude: 114.13471096737511)
let cym = CLLocationCoordinate2D(
    latitude: 22.28272175206024, longitude: 114.1388863655295)
let cyc = CLLocationCoordinate2D(
    latitude: 22.28306337971004, longitude: 114.135406794366)
let eh = CLLocationCoordinate2DMake(1, 2)
//    let eh = CLLocationCoordinate2D(
//        latitude: 22.28254200737399, longitude: 114.13974252320251)
//    let hkw = CLLocationCoordinate2D(
//        latitude: 22.282939102246427, longitude: 114.13670858347567)
//    let ml = CLLocationCoordinate2D(
//        latitude: 22.28324557986716, longitude: 114.13774841808377)
//    let lily = CLLocationCoordinate2D(
//        latitude: 22.28276130735827, longitude: 114.13840809436599)
//    let vc = CLLocationCoordinate2D(
//        latitude: 22.28397262458758, longitude: 114.13422906552947)
