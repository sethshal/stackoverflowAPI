//
//  StackOverflowLabel.swift
//  StackOverflowAPITest
//
//  Created by Kriti Aarav on 12/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class StackOverflowLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        self.backgroundColor = UIColor.white
        self.textColor = UIColor.black
    }

}
