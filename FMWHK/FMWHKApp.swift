//
//  FMWHKApp.swift
//  FMWHK
//
//  Created by Sam Ng on 17/11/2023.
//

import SwiftUI
import CoreLocation

@main
struct FMWHKApp: App {
    @StateObject private var globalData = GlobalData()
    @StateObject private var showMenuBtn = ShowMenuBtn(true)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalData)
                .environmentObject(showMenuBtn)
                .task {
                    await globalData.updateAll()
                }
        }
    }
}
