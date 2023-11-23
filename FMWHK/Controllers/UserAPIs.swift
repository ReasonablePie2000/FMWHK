//
//  UserAPIs.swift
//  FMWHK
//
// ELEC3644 Group 1
// Team Member: LEE Cheuk Yin (3036037176)
//              NG Kong Pang (3035721706)
//              KWOK Yan Shing (3035994432)

import Foundation
import CoreLocation

let backendUrl = "https://elec3644_group1_backend.linksofrich.com"
// User endpoints
let loginEP = "/users/Login";
let resetPwEmailEP = "/users/ResetPasswordEmail";
let resetPwEP = "/users/ResetPassword";
let getUserEP = "/users/GetUser";
let createUserEP = "/users/CreateUser";
let updateUserInfoEP = "/users/UpdateUserInfo";
let deleteAccEP = "/users/DeleteUser";
let checkNameEmailEP = "/users/CheckNameEmail";
let AddFriendEP = "/users/AddFriend";
let GetUserLocEP = "/users/GetFriendLoc";
let UpdateUserLocEP = "/users/UpdateUserLoc";
let GetFriendLocEP = "/users/GetFriendLoc";

enum LoginStatus {
    case success
    case incorrectEntry
    case serverError
    case error
}

enum WebStatus {
    case success
    case serverError
    case error
}

struct UserAccount: Codable {
    let user_id: Int
    let user_name: String
    let first_name: String
    let last_name: String
    let email: String
    let role: String
    let phone: String
    let address: String
    let status: String
    let created_at: String
    let last_login_at: String
    let accessToken: String?
}

class FriendLocationList: Decodable {
    var friendLocations: [FriendLocation]
}

class FriendLocation: Decodable, Identifiable {
    var user_name: String
    var latitude: String?
    var longitude: String?
    var last_update_loc: String?
}

func userLogin(userNameOrEmail: String, password: String) async -> (LoginStatus, UserAccount?) {
    let url = URL(string: "\(backendUrl)\(loginEP)")!
    
    let body = [
        "user_name": userNameOrEmail,
        "email": userNameOrEmail,
        "password": password
    ]
    let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = bodyData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Server error")
            return (.serverError, nil)
        }
        
        if httpResponse.statusCode == 200 {
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let user = try decoder.decode(UserAccount.self, from: data)
            
            
            // Save the JWT token
            let defaults = UserDefaults.standard
            defaults.setValue(user.accessToken, forKey: "jwt")
            
            print("Login success")
            return (.success, user)
        } else if httpResponse.statusCode == 403 {
            return (.incorrectEntry, nil)
        } else {
            print("Login failed")
            return (.serverError, nil)
        }
    } catch {
        print("Error occurred: \(error)")
        return (.error, nil)
    }
}

func CheckJWTLogin() async -> (LoginStatus, UserAccount?) {
    do {
        let defaults = UserDefaults.standard
        guard let jwt = defaults.string(forKey: "jwt") else {
            return (LoginStatus.error, nil)
        }

        guard let url = URL(string: "\(backendUrl)\(getUserEP)") else {
            print("Invalid URL")
            return (LoginStatus.error, nil)
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print("Login failed")
            return (LoginStatus.error, nil)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        let user = try decoder.decode(UserAccount.self, from: data)
        
        print("JWTLogin")
        return (LoginStatus.success, user)
    } catch {
        print("Error loading initial data: \(error)")
    }
    
    return (LoginStatus.error, nil)
}

func AddFriend(userID: String, userName: String, userBName:String) async -> WebStatus {
    do {
        let defaults = UserDefaults.standard
        guard let jwt = defaults.string(forKey: "jwt") else {
            return WebStatus.error
        }

        guard let url = URL(string: "\(backendUrl)\(AddFriendEP)") else {
            print("Invalid URL")
            return WebStatus.error
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let bodyData = ["user_id": userID, "user_name": userName,
                        "userB_name": userBName] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData)


        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print("Add friend failed")
            return WebStatus.error
        }

        return WebStatus.success
    } catch {
        print("Error loading initial data: \(error)")
    }
    
    return WebStatus.error
}

func GetFriendsLocation(userID: String, userName: String) async -> [FriendLocation] {
    do {
        let defaults = UserDefaults.standard
        guard let jwt = defaults.string(forKey: "jwt") else {
            return []
        }

        guard let url = URL(string: "\(backendUrl)\(GetFriendLocEP)") else {
            print("Invalid URL")
            return []
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let bodyData = ["user_id": userID, "user_name": userName]
                request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print("Request failed")
            return []
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        let friendsLocs = try decoder.decode(FriendLocationList.self, from: data)
        
        for friend in friendsLocs.friendLocations {
            print(friend.user_name)
            print(friend.latitude ?? "Nil")
            print(friend.longitude ?? "Nil")
            print(friend.last_update_loc ?? "Nil")
        }
        return friendsLocs.friendLocations
    } catch {
        print("Error loading initial data: \(error)")
    }
    
    return []
}
