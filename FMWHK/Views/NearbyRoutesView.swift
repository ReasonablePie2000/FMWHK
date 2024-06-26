//
//  NearbyRoutesView.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import SwiftUI

struct NearbyRoutesView: View {
    @EnvironmentObject var globalData: GlobalData
    
    @State var timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                mainBkColor.ignoresSafeArea()
                ScrollView {
                    VStack{
                        Spacer()
                        ForEach(globalData.nearbyRoutes.sorted(by: { $0.routeStop.seq < $1.routeStop.seq }), id: \.self) { route in
                            NavigationLink(destination: RouteView(route: route.route)) {
                                VStack {
                                    RouteRowView(route: route.route)
                                        .frame(width: UIScreen.screenWidth * 0.9, height: 80)
                                        .background(mainBkColor)
                                        .cornerRadius(10)
                                        .padding(5)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    Task{
                        await globalData.updateAll()
                    }
                }
                .refreshable {
                    await globalData.updateAll()
                }
                .onReceive(timer) { _ in
                    Task{
                        await globalData.updateAll()
                    }
                }
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
