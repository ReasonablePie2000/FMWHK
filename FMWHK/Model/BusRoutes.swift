//
//  BusRoutes.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import Foundation
import CoreLocation
import SwiftUI

struct Stop: Codable {
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

struct StopList: Codable {
    let type: String
    let version: String
    let generatedTimestamp: String
    let data: [Stop]
}

struct StopETAList: Codable {
    let type: String
    let version: String
    let generatedTimestamp: String
    let data: [StopETA]
}

struct StopETA: Codable, Hashable {
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

enum NetworkError: Error{
    case invalidURL
    case invalidResponse
    case invalidData
}

func getStopData() async throws -> [Stop] {
    let endpoint = "https://data.etabus.gov.hk/v1/transport/kmb/stop"
    
    guard let url = URL(string: endpoint) else {
        throw NetworkError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw NetworkError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let stopList = try decoder.decode(StopList.self, from: data)
        return stopList.data
    } catch {
        throw NetworkError.invalidData
    }
}

func getStopETAData(stopID : String) async throws -> [StopETA] {
    let endpoint = "https://data.etabus.gov.hk/v1/transport/kmb/stop-eta/\(stopID)"
    
    guard let url = URL(string: endpoint) else {
        throw NetworkError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw NetworkError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let stopETAList = try decoder.decode(StopETAList.self, from: data)
        return stopETAList.data
    } catch {
        print("Error info: \(error)")
        throw NetworkError.invalidData
    }
}

func getNearestStops(_ stopList: [Stop], k: Int, srcCoordinate: CLLocation) -> [Stop] {
    var resultStopList: [Stop] = []
    var resultStopIDList: [String] = []
    var stopDistDict: [String: Double] = [:]
    
    for stop in stopList {
        stopDistDict[stop.stop] = srcCoordinate.distance(from: stop.location)
    }
    
    for _ in 0...k {
        let nearestStop = stopDistDict.min { $0.value < $1.value }
        resultStopIDList.append(nearestStop!.key)
        stopDistDict.removeValue(forKey: nearestStop!.key)
    }
    
    for stopID in resultStopIDList {
        if let i = stopList.firstIndex(where: { $0.stop == stopID }) {
            resultStopList.append(stopList[i])
        }
    }
    
    return resultStopList
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

