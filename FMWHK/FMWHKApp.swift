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
    @StateObject private var userData = UserData()
    @StateObject private var menuBarOject = MenuBarOject()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalData)
                .environmentObject(userData)
                .environmentObject(menuBarOject)
                .task {
                    await userData.checkIfLogin()
                    await globalData.updateAll()
                }
        }
    }
}
