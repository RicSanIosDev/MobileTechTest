//
//  ComentsResponse.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import Foundation

// MARK: - CommentsResponse
struct CommentsResponse: Codable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}
