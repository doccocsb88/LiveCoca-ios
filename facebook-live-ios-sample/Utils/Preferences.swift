//
//  Preferences.swift
//  facebook-live-ios-sample
//
//  Created by Macintosh HD on 8/29/18.
//  Copyright © 2018 Hans Knoechel. All rights reserved.
//

import Foundation
struct Defaults {
    static let KEY_REMEMBER_INFO = "key_remember"
    static let KEY_SAVE_PASSWORD = "key_save_password"
    static let KEY_SAVE_USERNAME = "key_save_username"
    static let KEY_TOKEN = "key_token"

    
    
    static func rememberPassword(_ save:Bool){
        UserDefaults.standard.set(save, forKey: KEY_REMEMBER_INFO)
        if !save{
            UserDefaults.standard.removeObject(forKey: KEY_SAVE_PASSWORD)
            UserDefaults.standard.removeObject(forKey: KEY_SAVE_USERNAME)

        }
    }
    static func isRemember() -> Bool{
        return UserDefaults.standard.bool(forKey: KEY_REMEMBER_INFO)
    }
    static func remember(username:String, password:String){
        if isRemember(){
            UserDefaults.standard.set(password, forKey: KEY_SAVE_PASSWORD)
            UserDefaults.standard.set(username, forKey: KEY_SAVE_USERNAME)
        }
    }
    static func getPassword() -> String{
        return UserDefaults.standard.string(forKey: KEY_SAVE_PASSWORD) ?? ""
    }
    static func getUsername() -> String{
        return UserDefaults.standard.string(forKey: KEY_SAVE_USERNAME) ?? ""
    }
    static func saveToken(_ token:String){
        UserDefaults.standard.set(token, forKey: KEY_TOKEN)

    }
    static func removeToken(){
        UserDefaults.standard.removeObject(forKey: KEY_TOKEN)
    }
    static func getToken() ->String?{
        return UserDefaults.standard.string(forKey: KEY_TOKEN)
    }
    static func isLogin() -> Bool{
        if let _  = UserDefaults.standard.string(forKey: KEY_TOKEN){
            return true
        }
        return false
    }
    static func clearData(){

    }
}
