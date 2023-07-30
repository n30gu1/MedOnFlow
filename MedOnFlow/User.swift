//
//  User.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import Foundation

class User {
    let uid: String
    let email: String?
    let photoURL: URL?
    
    init(uid: String, email: String?, photoURL: URL?) {
        self.uid = uid
        self.email = email
        self.photoURL = photoURL
    }
}
