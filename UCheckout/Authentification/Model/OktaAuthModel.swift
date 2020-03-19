//
//  OktaAuthModel.swift
//  UCheckout
//
//  Created by i2i innovation on 12/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct OktaAuthModel: Codable {
    let expiresAt, status, sessionToken: String?
    let embedded: Embedded?
    let links: Links?
    var errorCode: String?
    var errorSummary: String?
    var errorLink: String?
    var errorId: String?
    
    enum CodingKeys: String, CodingKey {
        case expiresAt, status, sessionToken
        case embedded = "_embedded"
        case links = "_links"
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    let user: SignedUser?
}

// MARK: - User
struct SignedUser: Codable {
    let id, passwordChanged: String?
    let profile: Profile?
}

// MARK: - Profile
struct Profile: Codable {
    let login, firstName, lastName, locale: String?
    let timeZone: String?
}

// MARK: - Links
struct Links: Codable {
    let cancel: Cancel?
}

// MARK: - Cancel
struct Cancel: Codable {
    let href: String?
    let hints: Hints?
}

// MARK: - Hints
struct Hints: Codable {
    let allow: [String]?
}
