//
//  StopView.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import SwiftUI

struct StopView: View {
    let stop: Stop
    @State var stopETAList: [StopETA]?
    //@EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ScrollView {
            VStack {
                Text(stop.nameTc)
                    .frame(width: UIScreen.screenWidth * 0.9)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .bold()
                Text(stop.nameEn)
                    .frame(width: UIScreen.screenWidth * 0.9)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .bold()
                MapView(coordinate: stop.location.coordinate, delta: 0.002)
                    .frame(width: UIScreen.screenWidth - 20, height: UIScreen.screenWidth - 20)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            //.onAppear{viewRouter.showMainMenu = true}
            //.onDisappear{viewRouter.showMainMenu = false}
            
            VStack{
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
                        //ScrollingText(text: Text("To \(stop.destEn)"), width: UIScreen.screenWidth * (3/5)).frame(width: UIScreen.screenWidth * (3/5))
                        //ScrollingText(text: Text(getMinTo(time: stop.eta ?? "No Data")), width: UIScreen.screenWidth * (1/5)).frame(width: UIScreen.screenWidth * (1/5))
                    }
                    .padding()
                }
            }
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
    }
    
    func getTimeFrom(stringDate: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:stringDate)
    }
    
    func getMinTo(time: String) -> String {
        guard let targetTime = getTimeFrom(stringDate: time) else {
            return "No scheduled departure at this moment"
        }
        
        let delta = targetTime - Date()
        
        if delta == 0 {
            return "-"
        } else {
            let formatter = DateComponentsFormatter()
            return formatter.string(from: delta) ?? "Invalid Time"
        }
    }
}

struct StopRowView: View {
    let stop: Stop
    
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


struct StopRowView_Previews: PreviewProvider {
    static var previews: some View {
        StopRowView(stop: tmpStop)
    }
}

