//
//  DatabaseManager.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(of email:String) -> String {
        return email.replacingOccurrences(of: ".", with: "-")
    }
    
    // MARK: Account Management
    
    /// insert user into Database
    public func insertUser(with user:ChatUser, completion: @escaping ((Bool) -> Void)){
        database.child(user.safeEmail).setValue([
            "firstName": user.firstName,
            "lastName": user.lastName
        ], withCompletionBlock: {
            error, _ in
            guard error == nil else {
                completion(false)
                print(error?.localizedDescription)
                return
            }
            
            completion(true)
        })
    }
    
    /// check if user is already in database
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        let safeEmail = DatabaseManager.safeEmail(of: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
        
    }
}

struct ChatUser {
    var firstName:String
    var lastName:String
    var emailAddress: String
    
    var safeEmail : String {
        return DatabaseManager.safeEmail(of: emailAddress)
    }
    
    var profileImageName : String {
        return "\(safeEmail)_profile_picture.png"
    }
}
