//
//  Story.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/5/23.
//

import Foundation
import ParseSwift

struct Story: ParseObject {
    // Required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    // Custom properties
    var coverFile: ParseFile?
    var user: User?
    var title: String?
    var description: String?
    var categories: [String]? // Each string is a category (ie. "Horror", "SciFi", etc)
    var chapters: [Chapter]?
    var isPublished: Bool? = false
}

struct Chapter: ParseObject {
    // Required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    // Custom properties
    var title: String?
    var content: String?
}
