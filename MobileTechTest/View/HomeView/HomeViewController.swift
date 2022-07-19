//
//  HomeViewController.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 14/7/22.
//

import UIKit
import PKHUD

protocol ListDelegate: AnyObject {
    func reloadTable(list: [Post], favoriteList: [Post])
}

enum listPostType: CaseIterable {
    case all
    case favorite
}

class HomeViewController: UIViewController {
    //MARK: -View components
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = listPostType.allCases.map { getSementedTitle(dateType: $0)}
        let segmented = UISegmentedControl(items: items)
        segmented.addTarget(self, action: #selector(segmentedDidChange), for: .valueChanged)
        segmented.selectedSegmentIndex = 0

        let primaryColor = UIColor.Base.primary
        segmented.fontBold(for: .selected, size: 16 ,color: .white)
        segmented.fontMedium(for: .normal, size: 12, color: primaryColor)
        segmented.selectedSegmentTintColor = primaryColor

        for segmentItem : UIView in segmented.subviews
        {
            for item : Any in segmentItem.subviews {
                if let i = item as? UILabel {
                    i.numberOfLines = 0
                    // change other parameters: color, font, height ...
                }
            }
        }
        return segmented
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = .zero
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return tableView
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        button.setTitle("Delete All", for: .normal)
        button.titleLabel?.medium(size: 18, color: .white)
        return button
    }()

    lazy var reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didPullToRefresh))


    //MARK: - Vars

    var postList: [Post] = []
    var postFavoriteList: [Post] = []
    lazy var presenter = HomePresenter(homeViewDelegate: self)
    var optionSelected: listPostType = .all

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        applyConstraint()
        loadTable()
        presenter.getPost()
        reloadButton.tintColor = .white
        navigationItem.rightBarButtonItem = reloadButton
    }

    //MARK: - Actions

    func loadTable() {
        tableView.register(UINib.init(nibName: PostCell.identifier, bundle: nil), forCellReuseIdentifier: PostCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func didPullToRefresh() {
        // Re-fetch data
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.presenter.getPost()
        }
    }

    @objc func deleteButtonPressed() {
        switch optionSelected {
        case .all:
            guard let _ = LocalRepository().getPostList() else {
                return
            }
            LocalRepository().deletePostList()
            postList.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .favorite:
            guard let list = LocalRepository().getFavoritePostList() else {
                return
            }
            presenter.removeFavorite(postFavoriteList: list)
            LocalRepository().deleteFavoritePostList()
            postFavoriteList.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc func segmentedDidChange(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            optionSelected = .all
            deleteButton.setTitle("Delete All", for: .normal)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case 1:
            optionSelected = .favorite
            deleteButton.setTitle("Delete All Favorite", for: .normal)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            optionSelected = .all
            deleteButton.setTitle("Delete All", for: .normal)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func getSementedTitle(dateType: listPostType) -> String {
        switch dateType {
        case .all: return "All"
        case .favorite: return "Favorite"
        }
    }
}

//MARK: -HomeViewDelegate

extension HomeViewController: HomeViewDelegate {

    func upload(list: [Post], favoriteList: [Post]) {
        postList = list
        postFavoriteList = favoriteList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showAlert(message: APIError) {
        DispatchQueue.main.async {
            self.showAlertAction(title: "Error", message: message.localizedDescription)
        }
    }

    func showActivity() {
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
    }

    func stopAndHidenActivity(typeOfHUD: HUDContentType) {
        DispatchQueue.main.async {
            HUD.flash(typeOfHUD, delay: 0.7, completion: {_ in
                HUD.hide()
            })
        }
    }
}

extension HomeViewController: ListDelegate {
    func reloadTable(list: [Post], favoriteList: [Post]) {
        postList = list
        postFavoriteList = favoriteList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Style

extension HomeViewController {
    private func initView() {
        view.backgroundColor = .white
        view.addAutoLayout(subview: segmentedControl)
        view.addAutoLayout(subview: tableView)
        view.addAutoLayout(subview: deleteButton)
    }

    private func applyConstraint() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            segmentedControl.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: segmentedControl.trailingAnchor, multiplier: 2),
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 2)
        ])

        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

//MARK: - Table

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailPost = ( optionSelected == .all ? postList[indexPath.row] : postFavoriteList[indexPath.row])
        vc.delegate = self
        vc.navigationItem.title = "Detail Post"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( optionSelected == .all ? postList.count : postFavoriteList.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as! PostCell
        cell.accessoryType = .disclosureIndicator
        switch optionSelected {
        case .all:
            let post = postList[indexPath.row]
            if post.favorite {
                cell.setupCell(title: post.title, icon: .star)
            } else {
                cell.setupCell(title: post.title)
            }
        case .favorite:
            let post = postFavoriteList[indexPath.row]
            cell.setupCell(title: post.title, icon: .star)
        }

        return cell
    }
}
