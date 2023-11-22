//
//  UserAPIs.swift
//  FMWHK
//
//  Created by Sam Ng on 23/11/2023.
//

import Foundation

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
let UpdateUserLocEP = "/users/UpdateUserLoc";


enum LoginStatus {
    case success
    case incorrectEntry
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

//
//Future<bool> userLogout() async {
//  //globals.isLogin = false;
//  user = UserAccount();
//  loginStateController.add(false);
//  cartStateController.add([]);
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  await prefs.remove("jwt");
//  print("Logout success.");
//  return true;
//}
//
//
//Future<bool> userRegister(
//    TextEditingController firstName,
//    TextEditingController lastName,
//    TextEditingController userName,
//    TextEditingController email,
//    TextEditingController phone,
//    TextEditingController address,
//    TextEditingController password) async {
//  final uri = Uri.https(backendUrl, createUserEP);
//  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
//
//  final response = await http.post(
//    uri,
//    headers: headers,
//    body: jsonEncode(<String, String>{
//      "user_name": userName.text.trim(),
//      "first_name": firstName.text.trim(),
//      "last_name": lastName.text.trim(),
//      "email": email.text.trim(),
//      "password": password.text.trim(),
//      "phone": phone.text.trim(),
//      "address": address.text.trim()
//    }),
//  );
//
//  if (response.statusCode != 200) {
//    // If the server did not return a 200 OK response,
//    // then throw an exception.
//    print('Failed to load album');
//    return false;
//  }
//  return true;
//}
//
//void getVerificationEmail(TextEditingController email) async {
//  final uri = Uri.https(backendUrl, resetPwEmailEP);
//  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
//
//  final response = await http.post(
//    uri,
//    headers: headers,
//    body: jsonEncode(<String, String>{'email': email.text}),
//  );
//
//  if (response.statusCode == 200) {
//    // If the server did return a 200 OK response,
//    // then parse the JSON.
//  } else {
//    // If the server did not return a 200 OK response,
//    // then throw an exception.
//  }
//}
//
//Future<bool> resetPassword(TextEditingController email,
//    TextEditingController code, TextEditingController password) async {
//  final uri = Uri.https(backendUrl, resetPwEP);
//  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
//  print(password.text);
//  final response = await http.post(
//    uri,
//    headers: headers,
//    body: jsonEncode(<String, String>{
//      "email": email.text,
//      "verification_type": VerificationType.reset_password.name,
//      "verification_string": code.text,
//      "new_password": password.text
//    }),
//  );
//
//  if (response.statusCode == 200) {
//    // If the server did return a 200 OK response,
//    // then parse the JSON.
//    return true;
//  } else {
//    print(response.statusCode);
//    // If the server did not return a 200 OK response,
//    // then throw an exception.
//    return false;
//  }
//}
