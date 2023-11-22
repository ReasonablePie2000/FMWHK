//
//  StopListView.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

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
                                        .background(lightBkColor)
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


#Preview {
    StopListView()
}
