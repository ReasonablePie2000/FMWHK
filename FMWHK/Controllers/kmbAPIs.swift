//
//  kmbAPIs.swift
//  FMWHK
//
//  Created by Sam Ng on 21/11/2023.
//

import Foundation
import CoreLocation
import SwiftUI

func getRouteData() async throws -> [KMBRoute] {
    let endpoint = "https://data.etabus.gov.hk/v1/transport/kmb/route/"
    
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
        let routeList = try decoder.decode(KMBRouteList.self, from: data)
        return routeList.data
    } catch {
        throw NetworkError.invalidData
    }
}

func getRouteStopData() async throws -> [KMBRouteStop] {
    let endpoint = "https://data.etabus.gov.hk/v1/transport/kmb/route-stop"
    
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
        let stopList = try decoder.decode(KMBRouteStopList.self, from: data)
        return stopList.data
    } catch {
        throw NetworkError.invalidData
    }
}

func getStopData() async throws -> [KMBStop] {
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
        let stopList = try decoder.decode(KMBStopList.self, from: data)
        return stopList.data
    } catch {
        throw NetworkError.invalidData
    }
}

func getStopETAData(stopID : String) async throws -> [KMBStopETA] {
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
        let stopETAList = try decoder.decode(KMBStopETAList.self, from: data)
        return stopETAList.data
    } catch {
        print("Error info: \(error)")
        throw NetworkError.invalidData
    }
}

func getNearestStops(_ stopList: [KMBStop], k: Int, srcCoordinate: CLLocation) -> [KMBStop] {
    var resultStopList: [KMBStop] = []
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

func getNearestRoutes(_ stopList: [KMBStop]) async throws -> Set<KMBRoute> {
    var routes = Set<KMBRoute>()
    for stop in stopList {
        let endpoint = "https://data.etabus.gov.hk/v1/transport/kmb/stop-eta/\(stop.stop)"
        
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
            let stopETAList = try decoder.decode(KMBStopETAList.self, from: data)
            
            let allRoutes = try await getRouteData()
            
            for route in stopETAList.data {
                for routeInAll in allRoutes {
                    if(route.route == routeInAll.route) {
                        routes.insert(routeInAll)
                    }
                }
            }
            
        } catch {
            print("Error info: \(error)")
            throw NetworkError.invalidData
        }
    }
    
    for route in routes{
        print("\(route.route)")
    }

    
    return routes
}

func getETA(stop: KMBStop, route: KMBRoute){
    
}
