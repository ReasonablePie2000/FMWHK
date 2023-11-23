//
//  LocationSharingView.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import SwiftUI
import CoreLocation

struct LocationSharingView: View {
    @EnvironmentObject var globalData: GlobalData
    @EnvironmentObject var userData: UserData
    @State private var locationList: [IdentifiableLocation] = []
    @State private var showingPopover = false
    @State private var friendLocationList: [FriendLocation] = []
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Spacer()
                    Button("Add Friend") {
                        showingPopover = true
                    }
                    .foregroundColor(mainColor)
                    .popover(isPresented: $showingPopover) {
                        AddFriendView(showingPopover: $showingPopover)
                    }
                }
                MapView(center: globalData.locationManager.region.center, span: 0.005, locations: locationList)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/3)
                    .cornerRadius(10)
                    .padding(.top)
                
                ForEach(friendLocationList) { friendLocation in
                    HStack {
                        Text(friendLocation.user_name)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        HStack{
                            Text("Distance: \(Int(CLLocation(latitude: globalData.locationManager.region.center.latitude, longitude: globalData.locationManager.region.center.longitude).distance(from: CLLocation(latitude: Double(friendLocation.latitude!) ?? 0, longitude: Double(friendLocation.longitude!) ?? 0)))) M");
                            
                            Text("Last Update: \(getMinAgo(time: friendLocation.last_update_loc!) ?? "-")")
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.screenWidth * 0.9, height: 80)
                }
            }
        }
        .onReceive(timer) { _ in
            Task{
                await updateFriendLoc()
            }
        }
        .refreshable {
            await updateFriendLoc()
        }
        .onAppear{
            Task{
                await updateFriendLoc()
            }
        }
    }
    
    func updateFriendLoc() async{
        locationList = [IdentifiableLocation(coordinate: globalData.locationManager.region.center, pinImage: "person.circle", text: "You")]
        
        friendLocationList = await GetFriendsLocation(userID: userData.userID, userName: userData.userName)
        
        for fdLocation in friendLocationList {
            locationList.append(IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: Double(fdLocation.latitude!) ?? 0, longitude: Double(fdLocation.longitude!) ?? 0), pinImage: "person", text: fdLocation.user_name))
        }
    }
}
