//
//  HomePresenter.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 14/7/22.
//

import Foundation
import PKHUD

protocol HomeViewDelegate: AnyObject {
    func upload(list: [Post], favoriteList: [Post])
    func showAlert(message: APIError)
    func showActivity()
    func stopAndHidenActivity(typeOfHUD: HUDContentType)
}

final class HomePresenter {
    private let api_Network = API_Network.shared
    weak private var delegate: HomeViewDelegate

    init(homeViewDelegate: HomeViewDelegate){
        self.delegate = homeViewDelegate
        }

    func getPost() {
        delegate.showActivity()
        api_Network.getPost { [weak self] result in
            switch result {

            case .success(let PostList):
                self?.delegate.stopAndHidenActivity(typeOfHUD: .success)
                if let favoriteList = LocalRepository().getFavoritePostList(){
                    self?.delegate.upload(list: PostList,favoriteList: favoriteList)
                } else {
                    self?.delegate.upload(list: PostList,favoriteList: [])
                }

            case .failure(let error):
                self?.delegate.stopAndHidenActivity(typeOfHUD: .error)
                self?.delegate.showAlert(message: error)
            }
        }
    }

    func removeFavorite(postFavoriteList: [Post]) {
        guard var postList = LocalRepository().getPostList() else {
            return
        }

        for i in postFavoriteList {
            let index = postList.firstIndex(where: {$0.id == i.id})
            postList[index!].favorite = !i.favorite
        }
        LocalRepository().savePost(post: postList)
        delegate.upload(list: postList, favoriteList: [])
    }
}
