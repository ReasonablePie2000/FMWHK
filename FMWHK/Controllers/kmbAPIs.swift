//
//  kmbAPIs.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

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

func getRouteETAData(route: String, serviceType: String, bound: String) async throws -> [KMBRouteETA] {
    let endpoint = "https://data.etabus.gov.hk/v1/transport/kmb/route-eta/\(route)/\(serviceType)"
    
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
        let routeETAList = try decoder.decode(KMBRouteETAList.self, from: data)
        
        let filteredRouteETAList = routeETAList.data.filter { $0.dir == bound }
        return filteredRouteETAList
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

func getNearestRoutes(_ stopList: [KMBStop], globalData: GlobalData) async throws -> [KMBNearbyRouteItemModel] {
    var resultList: [KMBNearbyRouteItemModel] = []
    var routeList = [KMBRoute]()
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
                        
                        if(!routeList.contains(routeInAll)){
                            routeList.append(routeInAll)
                            let tmpRouteStopModel = await getRouteStopModels(routeInAll, globalData: globalData, forStop: stop)
                            
                            if(tmpRouteStopModel.count > 0) {
                                resultList.append(KMBNearbyRouteItemModel(route: routeInAll, routeStop: tmpRouteStopModel[0]))
                            }
                        }
                    }
                }
            }
            
        } catch {
            print("Error info: \(error)")
            throw NetworkError.invalidData
        }
    }
    
    return resultList
}

func getRouteStopModels(_ route: KMBRoute, globalData: GlobalData, forStop: KMBStop? = nil) async -> [RouteStopModel] {
    var resultList: [RouteStopModel] = []
    var routeStopList: [KMBRouteStop] = []
    do{
        let etaList = try await getRouteETAData(route: route.route, serviceType: route.serviceType, bound: route.bound)
        
        for routeStop in globalData.globalRouteStop{
            if(route.route == routeStop.route && route.bound == routeStop.bound){
                routeStopList.append(routeStop)
            }
        }
        
        for routeStop in routeStopList.sorted(by: { Int($0.seq) ?? 0 < Int($1.seq) ?? 0 }){
            for stop in globalData.globalStops{
                if(routeStop.stop == stop.stop){
                    var routeETAList: [KMBRouteETA] = []
                    for eta in etaList{
                        if(String(eta.seq) == routeStop.seq){
                            routeETAList.append(eta)
                        }
                    }
                    
                    if(forStop == nil || stop.stop == forStop?.stop){
                        resultList.append(RouteStopModel(seq: routeStop.seq, stop: stop, routeETA: routeETAList, distance: Float(CLLocation(latitude: globalData.locationManager.region.center.latitude, longitude: globalData.locationManager.region.center.longitude).distance(from: stop.location))))
                    }
                }
            }
        }
    } catch {
        print("Error info: \(error)")
    }
    
    return resultList
}

func getStopList(_ route: KMBRoute, globalData: GlobalData) -> [KMBStop] {
    var resultList: [KMBStop] = []
    var tmpStopList: [KMBRouteStop] = []
    for routeStop in globalData.globalRouteStop{
        if(route.route == routeStop.route && route.bound == routeStop.bound){
            tmpStopList.append(routeStop)
        }
    }
    
    for routeStop in tmpStopList.sorted(by: { Int($0.seq) ?? 0 < Int($1.seq) ?? 0 }){
        for stop in globalData.globalStops{
            if(routeStop.stop == stop.stop){
                resultList.append(stop)
            }
        }
    }
    
    return resultList
}
