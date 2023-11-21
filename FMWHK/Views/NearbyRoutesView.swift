//
//  NearbyRoutesView.swift
//  FMWHK
//
//  Created by Sam Ng on 21/11/2023.
//

import SwiftUI

struct NearbyRoutesView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var globalData: GlobalData
    
    var body: some View {
        NavigationView {
            ZStack {
                mainBkColor.ignoresSafeArea()
                ScrollView {
                    VStack{
                        Spacer()
                        ForEach(Array(globalData.nearbyRoutes).sorted(by: { $0.route < $1.route }), id: \.self) { route in
                            NavigationLink(destination: RouteView(route: route)) {
                                VStack {
                                    RouteRowView(route: route)
                                        .frame(width: UIScreen.screenWidth * 0.9, height: 80)
                                        .background(lightBkColor)
                                        .cornerRadius(10)
                                        .padding(5)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

struct RouteRowView: View {
    let route: KMBRoute
    
    var body: some View {
        HStack {
            Text(route.route)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 80, alignment: .leading)
            Spacer()
            VStack {
                Text("To \(route.destEn)")
                    .font(.title2)
                    .bold()
                Text(route.origEn)
                    .font(.caption)
                    .bold()
            }
            .multilineTextAlignment(.leading)
            .frame(width: 200, alignment: .leading)
            .foregroundColor(Color.white)
        }
        .frame(width: UIScreen.screenWidth * 0.8)
    }
}

#Preview {
    NearbyRoutesView()
}
