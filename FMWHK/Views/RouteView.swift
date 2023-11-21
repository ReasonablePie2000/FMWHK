//
//  RouteView.swift
//  FMWHK
//
//  Created by Sam Ng on 22/11/2023.
//

import SwiftUI
import CoreLocation

struct RouteView: View {
    let route: KMBRoute
    @State var routeStopList: [KMBStop]?
    @State var routeRowList: [RouteRow]?
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var showMenuBtn: ShowMenuBtn
    @EnvironmentObject var globalData: GlobalData
    @Environment(\.presentationMode) var presentationMode
    
    init(route: KMBRoute) {
        self.route = route
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ScrollView {
            VStack{
                MapView(coordinate: locationManager.region.center, delta: 0.002)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/3)
                    .cornerRadius(10)
                    .padding(.top)
                
                ForEach(routeRowList ?? [RouteRow](), id: \.self) { stop in
                    VStack{
                        Divider()
                            .background(.white)
                        HStack{
                            VStack{
                                Text("\(stop.seq). \(stop.stop.nameEn)")
                                    .bold()
                                Text("Distance: \(Int(stop.distance) / 1000) KM")
                                    .font(.caption)
                            }
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.screenWidth * 0.6, alignment: .leading)
                            
                            VStack{
                                ForEach(stop.routeETA, id: \.self) { eta in
                                    Text("\(getMinTo(time: eta.eta)) Mins")
                                        .bold()
                                }
                            }
                        }
                        .frame(width: UIScreen.screenWidth * 0.9, alignment: .center)
                        .padding()
                    }
                }
            }
            .onAppear{showMenuBtn.isShow = false}
            .task{
                routeRowList = await getRouteRow(route)
                routeStopList = getStopList(route)
            }
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(Color.white)
        .background(mainBkColor)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack{
                    Button {
                        showMenuBtn.isShow = true
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                    }
                    Text(route.route)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .bold()
                        .padding(.trailing)
                    Text("To")
                        .foregroundStyle(.white)
                    Text(route.destEn)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .bold()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func getRouteRow(_ route: KMBRoute) async -> [RouteRow] {
        var resultList: [RouteRow] = []
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
                        
                        resultList.append(RouteRow(seq: routeStop.seq, stop: stop, routeETA: routeETAList, distance: Float(CLLocation(latitude: locationManager.region.center.latitude, longitude: locationManager.region.center.longitude).distance(from: stop.location))))
                    }
                }
            }
        
            
        } catch {
            print("Error info: \(error)")
        }
        
        return resultList
    }
    
    func getStopList(_ route: KMBRoute) -> [KMBStop] {
        var resultList: [KMBStop] = []
        var stopList: [KMBRouteStop] = []
        for routeStop in globalData.globalRouteStop{
            if(route.route == routeStop.route && route.bound == routeStop.bound){
                stopList.append(routeStop)
            }
        }
        
        for routeStop in stopList.sorted(by: { Int($0.seq) ?? 0 < Int($1.seq) ?? 0 }){
            for stop in globalData.globalStops{
                if(routeStop.stop == stop.stop){
                    resultList.append(stop)
                }
            }
        }
        
        return resultList
    }
    
    func getTimeFrom(stringDate: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:stringDate)
    }
    
    func getMinTo(time: String) -> String {
        guard let targetTime = getTimeFrom(stringDate: time) else {
            return "No scheduled departure at this moment"
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
}
