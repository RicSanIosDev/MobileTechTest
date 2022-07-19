//
//  PostResponse.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import Foundation

// MARK: - PostResponseElement
struct PostResponseElement: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


typealias PostResponse = [PostResponseElement]
