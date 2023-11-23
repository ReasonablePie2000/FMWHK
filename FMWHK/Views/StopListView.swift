//
//  StopListView.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import SwiftUI
import Foundation
import CoreLocation
import Combine

struct StopListView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var globalData: GlobalData
    
    var body: some View {
        NavigationView {
            ZStack {
                mainBkColor.ignoresSafeArea()
                ScrollView {
                    VStack{
                        Spacer()
                        ForEach(globalData.nearbyStops, id: \.stop) { stop in
                            NavigationLink(destination: StopView(stop: stop)) {
                                VStack {
                                    StopRowView(stop: stop)
                                        .frame(width: UIScreen.screenWidth * 0.9, height: 80)
                                        .background(mainBkColor)
                                        .cornerRadius(10)
                                        .padding(10)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    await globalData.updateAll()
                }
            }
        }
    }
}


//#Preview {
//    StopListView()
//}
