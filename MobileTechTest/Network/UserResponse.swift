//
//  UserResponse.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 18/7/22.
//

import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
    let id: Int
    let name, username, email, phone, website: String
}
