//
//  FAQModel.swift
//  UCheckout
//
//  Created by Nilesh on 11/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct FAQModel: Codable {
    let ack: String?
    let faqs: [FAQ]?
}

// MARK: - FAQ
struct FAQ: Codable {
    let id: String?
    let category: String?
    let question, answer: String?
    var isExpanded : Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case category = "Category"
        case question = "Question"
        case answer = "Answer"
    }
}

class FAQCategoryModel {
    var category : String?
    var faq : [FAQ]?

}


