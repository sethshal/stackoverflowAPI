//
//  AcitvityIndicator.swift
//  StackOverflowAPITest
//
//  Created by Kriti Aarav on 12/5/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator: NSObject {
    
    var myActivityIndicator:UIActivityIndicatorView!
    
    func StartActivityIndicator(obj:UIViewController) -> UIActivityIndicatorView
    {
        
        self.myActivityIndicator = UIActivityIndicatorView  (style: UIActivityIndicatorView.Style.gray)
        self.myActivityIndicator.style = UIActivityIndicatorView.Style.gray
        let transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        self.myActivityIndicator.transform = transform;
        self.myActivityIndicator.center = obj.view.center
        obj.view.addSubview(myActivityIndicator)
        self.myActivityIndicator.bringSubviewToFront(obj.view)
        self.myActivityIndicator.hidesWhenStopped = true
        self.myActivityIndicator.startAnimating();
        self.myActivityIndicator.isHidden = false
        return self.myActivityIndicator;
    }
    
    func StopActivityIndicator(obj:UIViewController,indicator:UIActivityIndicatorView)-> Void
    {
        indicator.removeFromSuperview();
    }
}
