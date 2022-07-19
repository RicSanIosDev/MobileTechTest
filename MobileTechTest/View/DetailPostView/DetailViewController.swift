//
//  DetailViewController.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import UIKit
import PKHUD

class DetailViewController: UIViewController {

//MARK: -View components
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.bold(size: 20, color: .black)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.bold(size: 20, color: .black)
        label.textAlignment = .left
        label.text = "Description"
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.medium(size: 18, color: .systemGray)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.bold(size: 20, color: .black)
        label.textAlignment = .left
        label.text = "User"
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.medium(size: 18, color: .systemGray)
        label.textAlignment = .left
        label.text = "Name"
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.medium(size: 18, color: .systemGray)
        label.textAlignment = .left
        label.text = "Email"
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.medium(size: 18, color: .systemGray)
        label.textAlignment = .left
        label.text = "Phone"
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    let websiteLabel: UILabel = {
        let label = UILabel()
        label.medium(size: 18, color: .systemGray)
        label.textAlignment = .left
        label.text = "Website"
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel,
                                                   emailLabel,
                                                   phoneLabel,
                                                   websiteLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.backgroundColor = .white
        return stack
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = .zero
        return tableView
    }()
    
    lazy var starButton = UIBarButtonItem(image: UIImage(systemName: iconCell.star.rawValue), style: .plain, target: self, action: #selector(addFavorite))
    
    lazy var deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(removePost))
    
    //    MARK: -Vars
    var comentsList: [CommentsResponse] = []
    lazy var presenter = DetailPresenter(detailViewDelegate: self)
    weak var delegate: ListDelegate?
    var favorite: Bool!
    var detailPost: Post! {
        didSet {
            setup(item: detailPost)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        applyConstraints()
        loadTable()
        presenter.getUser(idUser: detailPost.userId)
        presenter.getComents(idPost: detailPost.id)
        
        if detailPost.favorite {
            starButton.tintColor = .systemYellow
        } else {
            starButton.tintColor = .white
        }
        navigationItem.rightBarButtonItems = [starButton, deleteButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        
        
    }
    
    //    MARK:- Actions
    @objc func addFavorite() {
        favorite = !favorite
        presenter.addFavorite(post: detailPost)
        if favorite {
            starButton.tintColor = .systemYellow
        } else {
            starButton.tintColor = .white
        }
        delegate?.reloadTable(list: presenter.getPostListCache(), favoriteList: presenter.getPostListFavorite())
    }
    
    @objc func removePost() {
        presenter.removePost(post: detailPost)
        delegate?.reloadTable(list: presenter.getPostListCache(), favoriteList: presenter.getPostListFavorite())
        backAction()
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

private extension DetailViewController {
    //MARK: - Configs
    
    private func setup(item: Post) {
        titleLabel.text = item.title
        commentLabel.text = item.coment
        favorite = item.favorite
        
    }
    
    func loadTable() {
        tableView.register(UINib.init(nibName: CommentsCell.identifier, bundle: nil), forCellReuseIdentifier: CommentsCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    //MARK: - Style
    
    private func initViews() {
        view.backgroundColor = .white
        view.addAutoLayout(subview: titleLabel)
        view.addAutoLayout(subview: descriptionLabel)
        view.addAutoLayout(subview: commentLabel)
        view.addAutoLayout(subview: userLabel)
        view.addAutoLayout(subview: stackView)
        view.addAutoLayout(subview: tableView)
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            commentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            commentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 16),
            userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: -DetailViewDelegate

extension DetailViewController: DetailViewDelegate {
    func updateUser(user: UserResponse) {
        DispatchQueue.main.async {
            self.nameLabel.text = user.name
            self.emailLabel.text = user.email
            self.phoneLabel.text = user.phone
            self.websiteLabel.text = user.website
        }
    }
    
    func upload(list: [CommentsResponse]) {
        comentsList = list
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

//MARK: - Style

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coment = comentsList[indexPath.row].body
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCell.identifier, for: indexPath) as! CommentsCell
        cell.setup(comment: coment)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.4)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "COMMENTS"
    }
}
