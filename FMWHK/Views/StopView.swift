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
    
    var body: some View {
        ScrollView {
            VStack {
                Text(stop.nameTc)
                    .font(.title)
                MapView(coordinate: stop.location.coordinate, delta: 0.002)
                    .frame(width: UIScreen.screenWidth - 20, height: UIScreen.screenWidth - 20)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            
            VStack{
                ForEach(stopETAList ?? [], id: \.self) { stop in
                    HStack{
                        Text("住 \(stop.destTc)")
                            .frame(width: UIScreen.screenWidth * (3/5))
                        Text(stop.route)
                            .frame(width: UIScreen.screenWidth * (1/5))
                        Text(getMinTo(time: stop.eta ?? "No Data"))
                            .frame(width: UIScreen.screenWidth * (1/5))
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
    }
    
    func getTimeFrom(stringDate: String) -> Date? {
        print(stringDate)
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:stringDate)
    }
    
    func getMinTo(time: String) -> String {
        let delta = (getTimeFrom(stringDate: time) ?? Date()) - Date()
        let formatter = DateComponentsFormatter()
        return formatter.string(from: delta) ?? "Invalid Time"
    }
}

struct StopRowView: View {
    let stop: Stop
    
    var body: some View {
        HStack {
            VStack {
                Text(stop.nameTc)
                    .font(.title3)
                Text(stop.nameEn)
                    .font(.title3)
            }
            .padding(10)
        }
    }
}

struct StopView_Previews: PreviewProvider {
    static var previews: some View {
        StopView(stop: tmpStop)
    }
}

struct StopRowView_Previews: PreviewProvider {
    static var previews: some View {
        StopRowView(stop: tmpStop)
    }
}

