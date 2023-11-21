//
//  BusRoutes.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import Foundation
import CoreLocation
import SwiftUI

struct KMBStop: Codable, Hashable {
    let stop: String
    let nameEn: String
    let nameTc: String
    let nameSc: String
    let lat: String
    let long: String
    
    var location: CLLocation {
        CLLocation (
            latitude: Double(lat) ?? 0.0,
            longitude: Double(long) ?? 0.0
        )
    }
}

struct KMBStopList: Codable {
    let type: String
    let version: String
    let generatedTimestamp: String
    let data: [KMBStop]
}

struct KMBStopETAList: Codable {
    let type: String
    let version: String
    let generatedTimestamp: String
    let data: [KMBStopETA]
}

struct KMBStopETA: Codable, Hashable {
    let co: String
    let route: String
    let dir: String
    let serviceType: Int
    let seq: Int
    let destTc: String
    let destSc: String
    let destEn: String
    let etaSeq: Int
    let eta: String?
    let rmkTc: String
    let rmkSc: String
    let rmkEn: String
    let dataTimestamp: String
}

// {"route":"67M","bound":"O","service_type":"1","seq":"1","stop":"7B966B22D0464566"}
struct KMBRouteStopList: Codable {
    let type: String
    let version: String
    let generatedTimestamp: String
    let data: [KMBRouteStop]
}

struct KMBRouteStop: Codable, Hashable {
    let route: String
    let bound: String
    let serviceType: String
    let seq: String
    let stop: String
}

struct KMBRouteList: Codable {
    let type: String
    let version: String
    let generatedTimestamp: String
    let data: [KMBRoute]
}

struct KMBRoute: Codable, Hashable {
    let route: String
    let bound: String
    let serviceType: String
    let origEn: String
    let origTc: String
    let origSc: String
    let destEn: String
    let destTc: String
    let destSc: String
}

struct KMBRouteETAList: Codable {
    let type: String
    let version: String
    let generatedTimestamp: String
    let data: [KMBRouteETA]
}

struct KMBRouteETA: Codable, Hashable {
    let co: String
    let route: String
    let dir: String
    let serviceType: Int
    let seq: Int
    let destTc: String
    let destSc: String
    let destEn: String
    let etaSeq: Int
    let eta: String
    let rmkTc: String
    let rmkSc: String
    let rmkEn: String
    let dataTimestamp: String
}

class GlobalData: ObservableObject{
    @Published var globalRoutes: [KMBRoute] = []
    @Published var globalStops: [KMBStop] = []
    @Published var nearbyStops: [KMBStop] = []
    @Published var nearbyRoutes: Set<KMBRoute> = []
    @Published var globalRouteStop: [KMBRouteStop] = []
}

struct RouteRow: Hashable{
    var seq: String
    var stop: KMBStop
    var routeETA: [KMBRouteETA]
    var distance: Float
}

enum NetworkError: Error{
    case invalidURL
    case invalidResponse
    case invalidData
}
