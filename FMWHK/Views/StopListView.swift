//
//  StopListView.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import SwiftUI
import Foundation
import CoreLocation
import Combine

struct StopListView: View {
    @State var stopList: [Stop]?
    @State var nearestStopList: [Stop]?
    @StateObject var locationManager = LocationManager()
    var userLocation: CLLocation {
        return CLLocation(latitude: locationManager.lastLocation?.coordinate.latitude ?? curLocation.coordinate.latitude, longitude: locationManager.lastLocation?.coordinate.longitude ?? curLocation.coordinate.longitude)
    }
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
        
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    ForEach(nearestStopList ?? [], id: \.stop) { stop in
                        NavigationLink(destination: StopView(stop: stop)) {
                            VStack {
                                StopRowView(stop: stop)
                                    .frame(width: UIScreen.screenWidth, height: 100)
                            }
                        }
                    }
                }
                .task{
                    do {
                        stopList = try await getStopData()
                        nearestStopList = getNearestStops(stopList ?? [], k: 10, srcCoordinate: userLocation)
                        print("\(userLatitude)")
                        print("\(userLongitude)")
                    } catch NetworkError.invalidURL {
                        print("invalid URL")
                    } catch NetworkError.invalidResponse {
                        print("invalid response")
                    } catch NetworkError.invalidData {
                        print("invalid data")
                    } catch {
                        print("unexpected error")
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
    
    func requestPermission() {
        switch locationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Location services were previously denied. Please enable location services for this app in settings.")
        case .authorizedWhenInUse, .authorizedAlways, .none:
            break
        @unknown default:
            print("Unknown location services authorization status")
        }
    }
}

#Preview {
    StopListView()
}
