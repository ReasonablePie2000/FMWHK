//
//  RouteView.swift
//  FMWHK
//
//  Created by Sam Ng on 22/11/2023.
//

import SwiftUI

struct RouteView: View {
    let route: KMBRoute
    @State var routeStopList: [KMBStop]?
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var isShowTitle: showTitle
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
                
                ForEach(routeStopList ?? [KMBStop](), id: \.self) { stop in
                    HStack{
                        Text(stop.nameEn)
                            .frame(width: UIScreen.screenWidth * (1/5))
                            .bold()
                            .font(.title)
                    }
                    .padding()
                }
            }
            .onAppear{isShowTitle.showTitle = false}
//            .task{
//                do {
//                    routeStopList = try await getStopETAData(stopID: stop.stop)
//                } catch NetworkError.invalidURL {
//                    print("invalid URL")
//                } catch NetworkError.invalidResponse {
//                    print("invalid response")
//                } catch NetworkError.invalidData {
//                    print("invalid data")
//                } catch {
//                    print("unexpected error")
//                }
//            }
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(Color.white)
        .background(mainBkColor)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack{
                    Button {
                        isShowTitle.showTitle = true
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    Text(route.route)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .bold()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
            return formatter.string(from: delta) ?? "Invalid Time"
        }
    }
}
