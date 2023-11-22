//
//  LoginView.swift
//  FMWHK
//
//  Created by Sam Ng on 23/11/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var failedMessage: String = ""
    @EnvironmentObject var menuBarOject: MenuBarOject
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack{
            mainBkColor.ignoresSafeArea()
            VStack{
                Text("Welcome To FMWHK")
                    .foregroundStyle(mainColor)
                    .font(.title)
                    .bold()
                Text("Find your way in Hong Kong")
                    .foregroundStyle(.white)
                    .font(.caption)
                    .padding(.top, 5)
                
                Text("Log in using email or user name")
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.top, 50)
                
                if(failedMessage != ""){
                    Text(failedMessage)
                        .bold()
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                TextField("Username", text: $username)
                    .padding()
                    .background(.white)
                    .cornerRadius(5)
                    .padding(.bottom, 20)
                    .frame(width: UIScreen.screenWidth * 0.8)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(.white)
                    .cornerRadius(5)
                    .padding(.bottom, 20)
                    .frame(width: UIScreen.screenWidth * 0.8)
                
                Button(action: {
                    Task{
                        let (loginStatus, userAccount) = await userLogin(userNameOrEmail: username, password: password)
                        
                        if(loginStatus == LoginStatus.error || loginStatus == LoginStatus.incorrectEntry){
                            failedMessage = "Invalid User Name or Password"
                        }else if(loginStatus == LoginStatus.serverError){
                            failedMessage = "Server Unreachable, please try again later."
                        }else{
                            await userData.login(userAccount: userAccount!)
                            failedMessage = ""
                        }
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.3)
                        .padding()
                        .background(mainColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button("Forgot password", action: {
                    
                })
                .foregroundStyle(mainColor)
                .padding()
                .padding(.top, 50)
                
                HStack{
                    Text("New user?")
                        .foregroundStyle(.white)
                    Button("Sign up", action: {
                        
                    })
                    .foregroundStyle(mainColor)
                }
                .padding()
            }
        }
        .onAppear(){
            menuBarOject.title = "Login"
        }
    }
}

//#Preview {
//    LoginView()
//}
