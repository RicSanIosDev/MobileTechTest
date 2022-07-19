//
//  PostCell.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import UIKit

enum iconCell: String {
    case circle = "circle.fill"
    case star = "star.fill"
}

class PostCell: UITableViewCell {

    // MARK: - Vars
    static let identifier = "PostCell"
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(title: String, icon: iconCell = .circle) {
        let image = UIImage(systemName: icon.rawValue)
        iconView.image = image
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        switch icon {
        case .circle:
            iconView.tintColor = UIColor.blue
        case .star:
            iconView.tintColor = UIColor.systemYellow
        }
        titleLabel.text = title
    }
    
}
