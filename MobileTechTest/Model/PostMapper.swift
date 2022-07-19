//
//  PostMapper.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import Foundation
//Todo lo guarda en cache, si mando a llamar el api de nuevo, debo agregar solo los post q no esten en cache
//si elimino un post lo debo eliminar en mi cache
//si elimino todo lo elimino de mi cache
//debo ordenar la lista de favoritos al principio de la lista


class PostMapper {
    
    static func mapPost(response: PostResponse) -> [Post] {
        if var postListCache = LocalRepository().getPostList(){
            for item in response {
                let post = Post(id: item.id, userId: item.userID, title: item.title, coment: item.body, favorite: findFavorite(idPost: item.id))

                if !findPost(post: post) {
                    postListCache.append(post)
                }
            }

            postListCache.sort { $0.favorite && !$1.favorite }

            return postListCache
        } else {
            var postList: [Post] = []
            for item in response {
                let post = Post(id: item.id, userId: item.userID, title: item.title, coment: item.body, favorite: findFavorite(idPost: item.id))

                if !findPost(post: post) {
                    postList.append(post)
                }
            }

            postList.sort { $0.favorite && !$1.favorite }

            return postList
        }
    }

//MARK: - FindPost in Favorite
    static func findFavorite(idPost: Int) -> Bool {
        guard let favorite = LocalRepository().getFavoritePostList() else {
            return false
        }

        if let _ = favorite.firstIndex(where: { $0.id == idPost }) {
            return true
        } else {
        return false
        }
    }

//    MARK: - FindPost in Cache
    static func findPost(post: Post) -> Bool {
        guard let postList = LocalRepository().getPostList() else {
            var newList: [Post] = []
            newList.append(post)
            LocalRepository().savePost(post: newList)
            return false
        }

        if let _ = postList.firstIndex(where: { $0.id == post.id }) {
            return true
        } else {
            var newList = LocalRepository().getPostList()
            newList?.append(post)
            LocalRepository().savePost(post: newList!)
            return false
        }
    }
}
