//
//  File.swift
//  ThunderChat
//
//  Created by Kurtis Hoang on 4/7/21.
//

import Foundation


struct K {
    //static allows for Constants.registerSegue in other files shown in registerViewcontroller's registeredPressed method
    static let registerSegue = "registerToChat"
    static let loginSegue = "loginToChat"
    static let cellIdentifier = "ReuseableCell"
    static let cellNibName = "MessageCell"
    static let appName = "⚡️ThunderChat"
    
    struct BrandColor {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "Messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
