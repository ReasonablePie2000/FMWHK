//
//  LocationSharingView.swift
//  FMWHK
//
//  Created by Sam Ng on 23/11/2023.
//

import SwiftUI

struct LocationSharingView: View {
    @EnvironmentObject var globalData: GlobalData
    @State private var locationList: [IdentifiableLocation] = []
    
    var body: some View {
        MapView(center: globalData.locationManager.region.center, span: 0.001, locations: locationList)
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/3)
            .cornerRadius(10)
            .padding(.top)
            .onAppear{
                locationList = [IdentifiableLocation(coordinate: globalData.locationManager.region.center, pinImage: "person.circle", text: "")]
            }
    }
}
