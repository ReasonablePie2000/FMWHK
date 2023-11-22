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
    @State var routeStopModelList: [RouteStopModel]?
    @EnvironmentObject var menuBarOject: MenuBarOject
    @EnvironmentObject var globalData: GlobalData
    @Environment(\.presentationMode) var presentationMode
    @State private var locationList: [IdentifiableLocation] = []
    
    init(route: KMBRoute) {
        self.route = route
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ScrollView {
            VStack{
                MapView(center: globalData.locationManager.region.center, span: 0.002, locations: locationList)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/3)
                    .cornerRadius(10)
                    .padding(.top)
                
                ForEach(routeStopModelList ?? [RouteStopModel](), id: \.self) { stop in
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
                                    Text("\(getMinTo(time: eta.eta ?? "No Data")) Mins")
                                        .bold()
                                }
                            }
                        }
                        .frame(width: UIScreen.screenWidth * 0.9, alignment: .center)
                        .padding()
                    }
                }
            }
            .onAppear{
                menuBarOject.isShowMenuBtn = false
                locationList = [IdentifiableLocation(coordinate: globalData.locationManager.region.center, pinImage: "person", text: "")]
            }
            .task{
                routeStopModelList = await getRouteStopModels(route, globalData: globalData)
                routeStopList = getStopList(route, globalData: globalData)
            }
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(Color.white)
        .background(mainBkColor)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack{
                    Button {
                        menuBarOject.isShowMenuBtn = true
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
}
