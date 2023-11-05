//
//  User.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/5/23.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    // Required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    // Required by ParseUser
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String : [String : String]?]?
    // Custom properties
    var library: [Story]?
}
