//
//  EditFriendsTableViewController.swift
//  Snapchat
//
//  Created by Nick on 2016-01-26.
//  Copyright © 2016 Nicholas Ivanecky. All rights reserved.
//

import UIKit
import Parse

class EditFriendsTableViewController: UITableViewController
{
    
    // MARK: - Properties
    @IBOutlet var tableview: UITableView!
    
    let cellAccessoryColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    
    var friends = [PFUser]()
    private var users = [PFUser]()
    private var currentUser = PFUser.currentUser()!
    
    struct Storyboard {
        static let CellIdentifier = "Friend Cell"
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Friends"
        fetchUsers()
        
    }
    
    private func fetchUsers()
    {
        let userQuery = PFUser.query()
        userQuery?.orderByAscending("username")
        userQuery?.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
            if error == nil {
                self.users = users as! [PFUser]
                self.tableView.reloadData()
            } else {
                print(error)
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath)

        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.username
        
        if self.isFriendWith(user) {
            cell.accessoryView = MSCellAccessory(type: MSCellAccessoryType.FLAT_CHECKMARK, color: self.cellAccessoryColor)
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
    
    
    
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let user = self.users[indexPath.row]
        let friendsRelation = currentUser.relationForKey("friendsRelation")
        
        if isFriendWith(user) {
            // unfriend
            cell?.accessoryView = nil
            for var i = 0; i < friends.count; i++ {
                if friends[i].objectId == user.objectId {
                    friends.removeAtIndex(i)
                }
            }
            
            friendsRelation.removeObject(user)
        } else {
            // add friend
            friendsRelation.addObject(user)
            cell?.accessoryView = MSCellAccessory(type: MSCellAccessoryType.FLAT_CHECKMARK, color: self.cellAccessoryColor)
        }
        
        currentUser.saveInBackgroundWithBlock { (success, error) -> Void in
            if error != nil {
                print(error)
            }
        }
        
    }
    
    // MARK: - Helper method
    
    private func isFriendWith(user: PFUser) -> Bool
    {
        for friend in friends {
            if friend.objectId! == user.objectId! {
                return true
            }
        }
        
        return false
    }
}



































