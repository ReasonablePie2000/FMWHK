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
    @EnvironmentObject var showMenuBtn: ShowMenuBtn
    @State private var isLandingPageDone: Bool = false
    
    let viewList: [ViewIdentifier] = menuViews
    
    var body: some View {
        if isLandingPageDone {
            ZStack {
                mainBkColor
                    .ignoresSafeArea()
                
                // Drawer View
                DrawerView(isDrawerOpen: $isDrawerOpen, selectedViewIndex: $selectedViewIndex, views: viewList)
                    .offset(x: isDrawerOpen ? 0 : -UIScreen.main.bounds.width)
                
                VStack {
                    if(showMenuBtn.isShow){
                        HStack {
                            Button(action: {
                                withAnimation {
                                    self.isDrawerOpen.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .imageScale(.large)
                                    .bold()
                                    .foregroundColor(mainColor)
                                    .padding()
                            }
                            .scaleEffect(1.5)
                            //.hidden(viewRouter.showMainMenu)
                            
                            Text(viewList[selectedViewIndex].name)
                                .font(.title)
                                .bold()
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                    
                    ForEach(viewList.indices, id: \.self) { index in
                        if index == selectedViewIndex {
                            viewList[index].view
                                .navigationBarTitle("", displayMode: .inline)
                                .navigationBarHidden(true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(mainBkColor)
                        }
                    }
                    .hidden(isDrawerOpen)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                withAnimation {
                                    self.isDrawerOpen.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .imageScale(.large)
                                    .bold()
                                    .foregroundColor(mainColor)
                                    .padding()
                            }
                            .scaleEffect(1.5)
                            
                            Text(viewList[selectedViewIndex].name)
                                .font(.title)
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                }
                .zIndex(1)
            }
        } else {
            LandingView(isLandingPageDone: $isLandingPageDone)
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
                Spacer()
                ForEach(views) { view in
                    Button(action: {
                        withAnimation {
                            self.isDrawerOpen = false
                            self.selectedViewIndex = view.id
                        }
                    }) {
                        Text(view.name)
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
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

