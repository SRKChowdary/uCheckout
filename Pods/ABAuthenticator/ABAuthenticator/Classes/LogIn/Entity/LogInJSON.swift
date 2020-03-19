//
//  LogInJSON.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/31/19.
//

import Foundation

public struct LogInJSON :Codable {
    
    enum ServerStatus: String {
        case success = "SUCCESS"
        case passwordExpired = "PASSWORD_EXPIRED"
    }
    
    var expiresAt, status, sessionToken: String?
    var embedded: Embedded?
    var links: Links?
    var errorCode:String?
    
    enum CodingKeys: String, CodingKey {
        case expiresAt, status, sessionToken, errorCode
        case embedded = "_embedded"
        case links = "_links"
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    var user: User?
}

// MARK: - User
struct User: Codable {
    var id, passwordChanged: String?
    var profile: Profile?
}

// MARK: - Profile
struct Profile: Codable {
    var login, firstName, lastName, locale, timeZone: String?
}

// MARK: - Links
struct Links: Codable {
    var cancel: Cancel?
}

// MARK: - Cancel
struct Cancel: Codable {
    var href: String?
    var hints: Hints?
}

// MARK: - Hints
struct Hints: Codable {
    var allow: [String]?
}
