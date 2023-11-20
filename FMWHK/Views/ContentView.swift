//
//  ContentView.swift
//  FMWHK
//
//  Created by Sam Ng on 17/11/2023.
//
import SwiftUI

struct ContentView: View {
    @State var isDrawerOpen: Bool = false
    @State var selectedViewIndex: Int = 0
    
    let views: [ViewIdentifier] = [
            ViewIdentifier(id: 0, name: "Home", view: AnyView(Text("Home Screen"))),
            ViewIdentifier(id: 1, name: "Screen One", view: AnyView(StopListView())),
            ViewIdentifier(id: 2, name: "Screen Two", view: AnyView(Text("Screen Two")))
        ]
    
    var body: some View {
        ZStack {
            // Main View based on selectedView
            Group {
                views[selectedViewIndex].view
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
                            .foregroundColor(mainColor)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
            .zIndex(1)
            
            // Drawer View
            DrawerView(isDrawerOpen: $isDrawerOpen, selectedViewIndex: $selectedViewIndex, views: views)
                .offset(x: isDrawerOpen ? 0 : -UIScreen.main.bounds.width)
        }
    }
}

struct DrawerView: View {
    @Binding var isDrawerOpen: Bool
    @Binding var selectedViewIndex: Int
    let views: [ViewIdentifier]
    
    var body: some View {
        ZStack {
            mainBkColor
                .ignoresSafeArea()
            VStack {
                ForEach(views) { view in
                    Button(action: {
                        withAnimation {
                            self.isDrawerOpen = false
                            self.selectedViewIndex = view.id
                        }
                    }) {
                        Text(view.name)
                    }
                }
                Spacer()
            }
            .padding()
            .foregroundColor(mainColor)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
