//
//  ContentView.swift
//  FMWHK
//
//  Created by Sam Ng on 17/11/2023.
//
import SwiftUI

struct ContentView: View {
    @State var isDrawerOpen: Bool = false
    @State var selectedView: String = "Home"
    
    var body: some View {
        ZStack {
            // Main View based on selectedView
            Group {
                switch selectedView {
                case "Home":
                    Text("Home Screen")
                case "Screen One":
                    StopListView()
                case "Screen Two":
                    Text("Screen Two")
                default:
                    Text("Home Screen")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .disabled(isDrawerOpen)
            
            // Drawer Button
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.isDrawerOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
            .zIndex(1)
            
            // Drawer View
            DrawerView(isDrawerOpen: $isDrawerOpen, selectedView: $selectedView)
                .offset(x: isDrawerOpen ? 0 : -UIScreen.main.bounds.width)
        }
    }
}

struct DrawerView: View {
    @Binding var isDrawerOpen: Bool
    @Binding var selectedView: String
    
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                Button(action: {
                    withAnimation {
                        self.isDrawerOpen = false
                    }
                }) {
                    Text("Close")
                }
                Button(action: {
                    withAnimation {
                        self.isDrawerOpen = false
                        self.selectedView = "Home"
                    }
                }) {
                    Text("Home")
                }
                Button(action: {
                    withAnimation {
                        self.isDrawerOpen = false
                        self.selectedView = "Screen One"
                    }
                }) {
                    Text("Stops Nearby")
                }
                Button(action: {
                    withAnimation {
                        self.isDrawerOpen = false
                        self.selectedView = "Screen Two"
                    }
                }) {
                    Text("Screen Two")
                }
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
