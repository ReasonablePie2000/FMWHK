//
//  FMWHKApp.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

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
