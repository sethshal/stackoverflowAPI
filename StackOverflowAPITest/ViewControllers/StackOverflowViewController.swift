//
//  StackOverflowViewController.swift
//  StackOverflowAPITest
//
//  Created by Kriti Aarav on 12/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage


class StackOverflowViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    
    @IBOutlet var stackOverflowTable: UITableView!
    var users = Array<StackOverflowUser>()
    var user = StackOverflowUser()
    var refreshControl = UIRefreshControl()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackOverflowTable.delegate = self
        stackOverflowTable.dataSource = self
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(StackOverflowViewController.refresh(sender:)), for: UIControl.Event.valueChanged)
        self.refreshControl.backgroundColor = UIColor.gray
        self.stackOverflowTable?.addSubview(refreshControl)
        self.stackOverflowTable.tableFooterView = UIView()
        self.stackOverflowTable.rowHeight = UITableView.automaticDimension
        self.stackOverflowTable.estimatedRowHeight = 200
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        loadUserData();
        // Do any additional setup after loading the view.
    }
    
    @objc func loadUserData(){
        let indicator = ActivityIndicator().StartActivityIndicator(obj: self)
        indicator.center = self.stackOverflowTable.center
        Alamofire.request("https://api.stackexchange.com/2.2/users?site=stackoverflow",encoding: JSONEncoding.default)
            .responseJSON {response in
                ActivityIndicator().StopActivityIndicator(obj: self, indicator: indicator)
                self.stopRefresh()
                switch response.result {
                case .success(let data):
                    print("response \(data)")
                    self.users = Array<StackOverflowUser>()
                    let json = JSON(data)
                    let fetchedUsers = json["items"]
                    for (_, subJson) in fetchedUsers {
                        let selectedUser = StackOverflowUser()
                        selectedUser.location =  subJson["location"].string ?? "Unavailable"
                        selectedUser.reputation = subJson["reputation"].int!
                        selectedUser.creation_date = subJson["creation_date"].double!
                        selectedUser.accept_rate = subJson["accept_rate"].int ?? 0
                        selectedUser.link = subJson["link"].string!
                        selectedUser.display_name =  subJson["display_name"].string!
                        let badges : [String: Int] = subJson["badge_counts"].object as! [String : Int]
                        selectedUser.profile_image = subJson["profile_image"].string!
                        //print(badges);
                        selectedUser.badges = badges
                        self.users.append(selectedUser)
                    }
                    self.stackOverflowTable.reloadData()
                case .failure(let error):
                    print("response.Error \(error)")
                    fallthrough
                default:
                    print("response.result \(response.result)")
                }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235;
        //return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;
        //return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Stackoverflow Users"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackuserCell", for: indexPath) as! StackTableViewCell
        user = self.users[(indexPath as NSIndexPath).row]
        let weblinkTapGesture = UITapGestureRecognizer(target: self, action: #selector(StackOverflowViewController.websiteTapped(_:)))
        weblinkTapGesture.delegate = self
        cell.userPicture.image = UIImage(named: "placeholder.png")
        cell.link.addGestureRecognizer(weblinkTapGesture)
        //cell.userName.text = user.display_name
        //cell.location.text = user.location
        let userDetails = user.display_name + ",\n" + user.location
        cell.userDetails.text = userDetails
        cell.link.text = "User Website"
        cell.link.tag = indexPath.row;
        var recognition :String = ""
        for (key,value) in user.badges {
            recognition = recognition + "\n" + key + " : " + String(value)
        }
        let formattedRecognitionStr = NSMutableAttributedString()
        formattedRecognitionStr.bold("Badges").normal(recognition + "\n").bold("\nAcceptance Rate\n").normal(String(user.accept_rate) + "%")
        cell.userBadges.attributedText = formattedRecognitionStr
        let formattedJoinDate = Date(timeIntervalSince1970: user.creation_date)
        let joinDate = "Joined on " + self.dateFormatter.string(from:formattedJoinDate)
        cell.joinDate.text = joinDate
        self.dateFormatter.string(from: formattedJoinDate)
        cell.userPicture.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.userPicture.sd_imageTransition = .fade
        cell.userPicture.sd_setImage(with: URL(string: user.profile_image), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    
    //     Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1;
    }
    
    @objc func websiteTapped(_ gesture:UITapGestureRecognizer){
        let tapLocation = gesture.location(in: self.stackOverflowTable)
        if let tapIndexPath = self.stackOverflowTable.indexPathForRow(at: tapLocation){
            let pickedUser = self.users[(tapIndexPath as NSIndexPath).row]
            let website = pickedUser.link
            let url = URL(string: website)
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(url!)) {
                application.openURL(url!)
            }
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        loadUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopRefresh(){
        if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    
    
}
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Light", size: 16.0)!]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)
        return self
    }
}

