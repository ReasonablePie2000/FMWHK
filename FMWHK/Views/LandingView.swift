//
//  LandingView.swift
//  FMWHK
//
//  Created by Sam Ng on 22/11/2023.
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import SwiftUI

struct LandingView: View {
    @EnvironmentObject var globalData: GlobalData
    @Binding var isLandingPageDone: Bool
    
    var body: some View {
        ZStack{
            mainBkColor.ignoresSafeArea()
            VStack {
                Text("Welcome To FMWHK")
                    .foregroundStyle(mainColor)
                    .bold()
                    .font(.title)
                Text("Find your way in Hong Kong")
                    .foregroundStyle(.white)
                    .font(.caption)
                ProgressView("Loading...", value: globalData.progress, total: 1.0)
                    .padding()
                    .foregroundColor(.white)
                    .progressViewStyle(LinearProgressViewStyle(tint: mainColor))
                    .frame(width: UIScreen.screenWidth * 0.8)
                    .padding()
            }
            .onAppear {
                Task {
                    await globalData.updateAll()
                    isLandingPageDone = true
                }
            }
        }
    }
}

