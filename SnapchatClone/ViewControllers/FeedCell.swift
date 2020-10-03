//
//  FeedCell.swift
//  SnapchatClone
//
//  Created by Yurii Sameliuk on 21/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
