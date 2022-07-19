//
//  API_Network.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 14/7/22.
//

import Foundation
import UIKit

enum APIError: Error {
    case unknown
    case emptyData
    case notConnection
    case mapError
}


class API_Network {

    static let shared: API_Network = API_Network()

    func getPost( completion: @escaping (Result<[Post], APIError>) -> Void)  {
        let session = URLSession.shared
         let constans = Constants()


        guard let url = URL(string: constans.getURLPosts()) else {
                 print("Connection Failed")
                completion(.failure(.notConnection))
                 return
             }

             let task = session.dataTask(with: url) {(data, urlResponse, error) in
                 if let error = error {
                     print("Ocurred Error: \(error.localizedDescription)")
                     completion(.failure(.unknown))
                     return
                 }

                 guard let data = data else {
                     print("Empty Data")
                     completion(.failure(.emptyData))
                     return
                 }

                 do {
                     let postResponse = try JSONDecoder().decode(PostResponse.self, from: data)
                     let post = PostMapper.mapPost(response: postResponse)
                     completion(.success(post))
                 } catch {
                     completion(.failure(.mapError))
                 }
             }; task.resume()
    }

    func getPostComments(idPost: Int, completion: @escaping (Result<[CommentsResponse], APIError>) -> Void)  {
        let session = URLSession.shared
         let constans = Constants()
        let baseUrl = constans.getURLComents(idPost: idPost)

        guard let url = URL(string: baseUrl) else {
                 print("Connection Failed")
                completion(.failure(.notConnection))
                 return
             }

             let task = session.dataTask(with: url) {(data, urlResponse, error) in
                 if let error = error {
                     print("Ocurred Error: \(error.localizedDescription)")
                     completion(.failure(.unknown))
                     return
                 }

                 guard let data = data else {
                     print("Empty Data")
                     completion(.failure(.emptyData))
                     return
                 }

                 do {
                     let commentsResponse = try JSONDecoder().decode([CommentsResponse].self, from: data)

                     completion(.success(commentsResponse))
                 } catch {
                     completion(.failure(.mapError))
                 }
             }; task.resume()
    }

    func getUser(idUser: Int, completion: @escaping (Result<UserResponse, APIError>) -> Void)  {
        let session = URLSession.shared
         let constans = Constants()
        let baseUrl = constans.getURLUser(idUser: idUser)

        guard let url = URL(string: baseUrl) else {
                 print("Connection Failed")
                completion(.failure(.notConnection))
                 return
             }

             let task = session.dataTask(with: url) {(data, urlResponse, error) in
                 if let error = error {
                     print("Ocurred Error: \(error.localizedDescription)")
                     completion(.failure(.unknown))
                     return
                 }

                 guard let data = data else {
                     print("Empty Data")
                     completion(.failure(.emptyData))
                     return
                 }

                 do {
                     let user = try JSONDecoder().decode(UserResponse.self, from: data)

                     completion(.success(user))
                 } catch {
                     completion(.failure(.mapError))
                 }
             }; task.resume()
    }
}
