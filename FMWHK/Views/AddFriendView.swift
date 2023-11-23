//
//  AddFriendView.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import SwiftUI

struct AddFriendView: View {
    @State private var username: String = ""
    @Binding var showingPopover: Bool
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack{
            lightBkColor.ignoresSafeArea()
            VStack{
                Text("Please enter the user name of the friend you wish to invite")
                    .foregroundStyle(mainColor)
                    .frame(width: UIScreen.screenWidth*0.8, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding()
                
                TextField("Username", text: $username)
                    .padding()
                    .background(.white)
                    .cornerRadius(5)
                    .padding(.bottom, 20)
                    .frame(width: UIScreen.screenWidth * 0.8)
                
                HStack{
                    Button(action: {
                        self.showingPopover = false
                    }) {
                        Text("Back")
                            .font(.headline)
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.3)
                            .padding()
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        Task{
                            await AddFriend(userID: userData.userID, userName: userData.userName, userBName: username)
                            self.showingPopover = false
                        }
                        
                    }) {
                        Text("Confirm")
                            .font(.headline)
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.3)
                            .padding()
                            .background(mainColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
            }
        }
    }
}

