//
//  Constants.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import Foundation



struct Constants {
    let baseUrl = "https://jsonplaceholder.typicode.com"
    
    enum Endpoints: String {
        case posts = "/posts"
        case comments = "/comments"
        case users = "/users"
    }

    func getURLUser(idUser: Int) -> String {
        return baseUrl + Endpoints.users.rawValue + "/\(idUser)"
    }

    func getURLPosts() -> String {
        return baseUrl + Endpoints.posts.rawValue
    }

    func getURLPost(idPost: Int) -> String {
        return baseUrl + Endpoints.posts.rawValue + "/\(idPost)"
    }

    func getURLComents(idPost: Int) -> String {
        return baseUrl + Endpoints.posts.rawValue + "/\(idPost)" + Endpoints.comments.rawValue
    }
}
