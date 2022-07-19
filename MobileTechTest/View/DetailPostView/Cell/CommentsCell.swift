//
//  CommentsCell.swift
//  MobileTechTest
//
//  Created by Ricardo Sanchez on 15/7/22.
//

import UIKit

class CommentsCell: UITableViewCell {
    
    // MARK: - Vars
    static let identifier = "CommentsCell"
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(comment: String) {
        commentLabel.text = comment
    }
    
}
