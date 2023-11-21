//
//  StopView.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import SwiftUI

struct StopView: View {
    let stop: KMBStop
    @State var stopETAList: [KMBStopETA]?
    @EnvironmentObject var showMenuBtn: ShowMenuBtn
    @EnvironmentObject var globalData: GlobalData
    @Environment(\.presentationMode) var presentationMode
    
    init(stop: KMBStop) {
        self.stop = stop
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ScrollView {
            VStack{
                MapView(coordinate: stop.location.coordinate, delta: 0.002)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/3)
                    .cornerRadius(10)
                    .padding(.top)
                
                ForEach(stopETAList ?? [], id: \.self) { stop in
                    HStack{
                        Text(stop.route)
                            .frame(width: UIScreen.screenWidth * (1/5))
                            .bold()
                            .font(.title)
                        Text("To \(stop.destEn)")
                            .frame(width: UIScreen.screenWidth * (3/5))
                        Text(getMinTo(time: stop.eta ?? "No Data"))
                            .frame(width: UIScreen.screenWidth * (1/5))
                    }
                    .padding()
                }
            }
            .onAppear{showMenuBtn.isShow = false}
            .task{
                do {
                    stopETAList = try await getStopETAData(stopID: stop.stop)
                } catch NetworkError.invalidURL {
                    print("invalid URL")
                } catch NetworkError.invalidResponse {
                    print("invalid response")
                } catch NetworkError.invalidData {
                    print("invalid data")
                } catch {
                    print("unexpected error")
                }
            }
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(Color.white)
        .background(mainBkColor)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack{
                    Button {
                        showMenuBtn.isShow = true
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                    }
                    Text(stop.nameEn)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .bold()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StopRowView: View {
    let stop: KMBStop
    
    var body: some View {
        HStack {
            VStack {
                Text(stop.nameTc)
                    .bold()
                Text(stop.nameEn)
                    .bold()
            }
            .foregroundColor(Color.white)
        }
    }
}

