//
//  ProfileView.swift
//  FMWHK
//
//  Created by Sam Ng on 20/11/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var menuBarOject: MenuBarOject
    
    var body: some View {
        if(userData.isLoggedIn)
        {
            VStack{
                Text("My Profile")
                    .font(.largeTitle)
                    .padding()
                    .padding(.bottom, 100)

                HStack{
                    Text("User Name:")
                        .font(.title3)
                        .padding()
                        .frame(width: 200, alignment: .leading)
                    
                    Text(userData.userName)
                        .padding()
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.5)
                }
                HStack{
                    Text("Email:")
                        .font(.title3)
                        .padding()
                        .frame(width: 200, alignment: .leading)
                    
                    Text(userData.userEmail)                        .padding()
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.5)
                }
                
                Button(action: {
                    Task{
                        await userData.logout()
                    }
                }) {
                    Text("Logout")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.3)
                        .padding()
                        .background(mainColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .padding(.top, 100)
                
            }
            .foregroundColor(.white)
            .onAppear(){
                menuBarOject.title = "Profile"
            }
        }
        else{
            LoginView()
        }
    }
}

