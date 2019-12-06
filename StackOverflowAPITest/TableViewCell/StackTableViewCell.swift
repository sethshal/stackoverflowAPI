//
//  StackTableViewCell.swift
//  StackOverflowAPITest
//
//  Created by Kriti Aarav on 12/4/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class StackTableViewCell: UITableViewCell {

    @IBOutlet var userDetails: UITextView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userBadges: UITextView!
    @IBOutlet var userPicture: UIImageView!
    
    @IBOutlet var joinDate: UILabel!
    @IBOutlet var location: UILabel!
    
    @IBOutlet var link: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
