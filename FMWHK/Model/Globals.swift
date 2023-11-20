//
//  Globals.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import Foundation
import SwiftUI


let mainBkColor = Color(hex: "101010")
let lightBkColor = Color(hex: "424242")
let mainColor = Color(hex: "4BD964")

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ViewIdentifier: Identifiable {
    let id: Int
    let name: String
    let view: AnyView
}

let menuViews = [
    ViewIdentifier(id: 0, name: "Home", view: AnyView(Text("Home Screen"))),
    ViewIdentifier(id: 1, name: "Nearby Bus Stops", view: AnyView(StopListView())),
    ViewIdentifier(id: 2, name: "Screen Two", view: AnyView(Text("Screen Two"))) 
]
