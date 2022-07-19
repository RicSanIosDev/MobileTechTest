//
//  DetailPresenter.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import Foundation
import PKHUD

protocol DetailViewDelegate: AnyObject {
    func upload(list: [CommentsResponse])
    func showAlert(message: APIError)
    func updateUser(user: UserResponse)
    func showActivity()
    func stopAndHidenActivity(typeOfHUD: HUDContentType)
}

final class DetailPresenter {
    private let api_Network = API_Network.shared
    weak private var delegate: DetailViewDelegate?
    
    init(detailViewDelegate: DetailViewDelegate){
        self.delegate = detailViewDelegate
    }    
    
    func getComents(idPost: Int) {
        delegate?.showActivity()
        api_Network.getPostComments(idPost: idPost, completion: { [weak self] result in
            switch result {
            case .success(let PostList):
                self?.delegate?.stopAndHidenActivity(typeOfHUD: .success)
                self?.delegate?.upload(list: PostList)
            case .failure(let error):
                self?.delegate?.stopAndHidenActivity(typeOfHUD: .error)
                self?.delegate?.showAlert(message: error)
            }
        })
    }
    
    func getUser(idUser: Int) {
        api_Network.getUser(idUser: idUser, completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.delegate?.updateUser(user: user)
            case .failure(let error):
                self?.delegate?.showAlert(message: error)
            }
        })
    }
    
    func addFavorite(post: Post) {
        guard var postListFavorite = LocalRepository().getFavoritePostList(), var postList = LocalRepository().getPostList() else {
            
            if var postList = LocalRepository().getPostList(){
                let indexP = postList.firstIndex(where: {$0.id == post.id})
                postList[indexP!].favorite = !post.favorite
                
                let newPost = Post(id: post.id, userId: post.userId, title: post.title, coment: post.coment, favorite: true)
                var postListFavorite: [Post] = []
                postListFavorite.append(newPost)
                postList.sort { $0.favorite && !$1.favorite }
                LocalRepository().saveFavoritePost(post: postListFavorite)
                LocalRepository().savePost(post: postList)
            }
            return
        }
        
        let indexP = postList.firstIndex(where: {$0.id == post.id})
        postList[indexP!].favorite = !post.favorite
        postList.sort { $0.favorite && !$1.favorite }
        LocalRepository().savePost(post: postList)
        
        
        if let indexF = postListFavorite.firstIndex(where: {$0.id == post.id}) {
            postListFavorite.remove(at: indexF)
            LocalRepository().saveFavoritePost(post: postListFavorite)
        } else {
            let newPost = Post(id: post.id, userId: post.userId, title: post.title, coment: post.coment, favorite: true)
            postListFavorite.append(newPost)
            LocalRepository().saveFavoritePost(post: postListFavorite)
        }
    }
    
    func removePost(post: Post) {
        guard var postListFavorite = LocalRepository().getFavoritePostList(), var postList = LocalRepository().getPostList() else {
            
            if var postList = LocalRepository().getPostList(){
                let indexP = postList.firstIndex(where: {$0.id == post.id})
                postList.remove(at: indexP!)
                LocalRepository().savePost(post: postList)
            }
            return
        }
        
        let indexP = postList.firstIndex(where: {$0.id == post.id})
        postList.remove(at: indexP!)
        LocalRepository().savePost(post: postList)
        
        
        if let indexF = postListFavorite.firstIndex(where: {$0.id == post.id}) {
            postListFavorite.remove(at: indexF)
            LocalRepository().saveFavoritePost(post: postListFavorite)
        }
    }
    
    
    func getPostListCache() -> [Post] {
        guard let postList = LocalRepository().getPostList() else {
            return []
        }
        return postList
    }
    
    func getPostListFavorite() -> [Post] {
        guard let postFavoriteList = LocalRepository().getFavoritePostList() else {
            return []
        }
        return postFavoriteList
    }
}
