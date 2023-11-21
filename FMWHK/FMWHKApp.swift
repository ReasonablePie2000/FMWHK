//
//  FMWHKApp.swift
//  FMWHK
//
//  Created by Sam Ng on 17/11/2023.
//

import SwiftUI
import CoreLocation

@main
struct FMWHKApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var globalData = GlobalData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(globalData)
                .environmentObject(showTitle(true))
                .environmentObject(titleName("Home"))
                .task {
                    do {
                        globalData.globalRoutes = try await getRouteData()
                        globalData.globalStops = try await getStopData()
                        globalData.nearbyStops = getNearestStops(globalData.globalStops, k: 5, srcCoordinate: CLLocation(latitude: locationManager.region.center.latitude, longitude: locationManager.region.center.longitude))
                        globalData.nearbyRoutes = try await  getNearestRoutes(globalData.nearbyStops)
                    } catch NetworkError.invalidURL {
                        print("invalid URL")
                    } catch NetworkError.invalidResponse {
                        print("invalid response")
                    } catch NetworkError.invalidData {
                        print("invalid data")
                    } catch {
                        print("Failed to fetch data: \(error)")
                    }
                }
        }
    }
}
