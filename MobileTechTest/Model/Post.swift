//
//  Post.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 14/7/22.
//

import Foundation

struct Post: Codable, Equatable {
    let id: Int
    let userId: Int
    let title: String
    let coment: String
    var favorite: Bool = false
}
