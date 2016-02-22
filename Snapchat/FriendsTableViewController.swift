//
//  FriendsTableViewController.swift
//  Snapchat
//
//  Created by Nick on 2016-01-26.
//  Copyright © 2016 Nicholas Ivanecky. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: UITableViewController
{

    var friends = [PFUser]()
    var currentUser: PFUser!
    var friendsRelation: PFRelation!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("view will appear. fetch new friends...")
        fetchFriends()
    }
    
    func fetchFriends() {
        currentUser = PFUser.currentUser()!
        
        if let friendsRelation = currentUser["friendsRelation"] as? PFRelation {
            let friendsQuery = friendsRelation.query()
            friendsQuery?.orderByAscending("username")
            friendsQuery?.findObjectsInBackgroundWithBlock({ (friends, error) -> Void in
                if error == nil {
                    self.friends = friends as! [PFUser]
                    self.tableView.reloadData()
                } else {
                    print (error)
                }
            })
            
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    struct Storyboard {
        static let CellIdentifier = "Friend Cell"
        static let ShowEditFriendsSegue = "Show Edit Friends"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath)
        
        let user = self.friends[indexPath.row]
        cell.textLabel?.text = user.username
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  Storyboard.ShowEditFriendsSegue {
            let editFriendsTVC = segue.destinationViewController as! EditFriendsTableViewController
            editFriendsTVC.friends = self.friends
        }
    }
    
    //MARK: Helper Method
    
    private func isFriendWith(user: PFUser) -> Bool{
        for friend in friends {
            if friend.objectId == user.objectId! {
                return true
            }
        }
        
        return false 
    }
    
    
}



















