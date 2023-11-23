//
//  ExploreView.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import SwiftUI
import MapKit


struct ExploreView:View {
    let buildingList = globalBuildingList
    
    var body: some View {
        NavigationView {
            ScrollView{
                ZStack {
                    mainBkColor.ignoresSafeArea()
                    VStack{
                        ForEach(buildingList, id: \.buildingName) { building in
                            NavigationLink(destination: BuildingView(buildingVM: building)) {
                                VStack {
                                    BuildingRowView(buildingVM: building)
                                        .background(mainBkColor)
                                        .foregroundStyle(.white)
                                        .cornerRadius(10)
                                        .padding(10)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
