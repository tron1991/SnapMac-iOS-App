//
//  InboxViewController.swift
//  Snapchat
//
//  Created by Nick on 2016-01-26.
//  Copyright © 2016 Nicholas Ivanecky. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class InboxViewController: UITableViewController
{
    
    //MARK: - Properties
    
     var messages = [PFObject]()
    private var selectedMessage: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() == nil {
            performSegueWithIdentifier("Show Log In", sender: nil)
        }
    }
    
    func fetchMessages() {
        
        if let currentUser = PFUser.currentUser() {
            let messageQuery = PFQuery(className: "Messages")
            messageQuery.whereKey("recipientIds", equalTo: currentUser.objectId!)
            messageQuery.orderByDescending("createdAt")
            
            messageQuery.findObjectsInBackgroundWithBlock({ (messages, error) -> Void in
                if error == nil, let messages = messages {
                    self.messages = messages
                    self.tableView.reloadData()
                    self.updateTabBarBadge()
                    
                } else {
                    print(error?.localizedDescription)
                }
                
                self.refreshControl?.endRefreshing()
            })
        }
        
    }
    
    func updateTabBarBadge() {
        let tabArray = (self.tabBarController?.tabBar.items)!
        let inboxItem = tabArray[0]
        
        if self.messages.count > 0 {
            inboxItem.badgeValue = "\(self.messages.count)"
        } else {
            inboxItem.badgeValue = nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchMessages", name: "reloadMessages", object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadMessages", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        fetchMessages()
    }
    
    // MARK: - UITableViewData
    
    struct Storyboard {
        static let messageCellIdentifer = "Message Cell"
        static let ShowLoginSegue = "Show Log In"
        static let ShowPhotoSegue = "Show Photo"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.messageCellIdentifer, forIndexPath: indexPath)
        let message = self.messages[indexPath.row]
        
        cell.textLabel?.text = message["senderName"] as? String
        
        let messageType = message["fileType"] as! String
        if messageType == "photo" {
            cell.imageView?.image = UIImage(named: "icon_photo")
        } else {
            cell.imageView?.image = UIImage(named: "icon_video")
        }
        
        return cell
    }
    
    
    // MARK: Target / Action
    
    @IBAction func refresh(sender: AnyObject) {
        fetchMessages()
        
    }
    
    // MARK: - UITableviewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let message = self.messages[indexPath.row]
        let fileType = message["fileType"] as! String
        self.selectedMessage = message
        
        if fileType == "photo" {
            //it is a photo message, let's show a photo
            self.performSegueWithIdentifier(Storyboard.ShowPhotoSegue, sender: nil)
            
        } else {
            //it is a video message, let's play the video message
            let videoFile = self.selectedMessage["file"] as! PFFile
            let fileURL = NSURL(string: videoFile.url!)
            let player = AVPlayer(URL: fileURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            self.presentViewController(playerViewController, animated: true, completion:{ () -> Void in
              playerViewController.player!.play()
            })
        }
        
        // delete the message
        
        var recipientIds = self.selectedMessage["recipientIds"] as! [String]
        if recipientIds.count == 1 {
            self.selectedMessage.deleteInBackground()
        } else {
            let currentUserObjectId = PFUser.currentUser()?.objectId!
            if let index = recipientIds.indexOf(currentUserObjectId!) {
                recipientIds.removeAtIndex(index)
            }
            
            self.selectedMessage["recipientIds"] = recipientIds
            self.selectedMessage.saveInBackground()
        }
    }
    
    
    
    @IBAction func logOutDidTap(sender: AnyObject)
    {
        PFUser.logOut()
        self.performSegueWithIdentifier("Show Log In", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Log In" {
            let loginSignupVC = segue.destinationViewController as! LoginSignupViewController
            loginSignupVC.hidesBottomBarWhenPushed = true
            loginSignupVC.navigationItem.hidesBackButton = true
            
        } else if segue.identifier == Storyboard.ShowPhotoSegue {
            let photoViewController = segue.destinationViewController as! PhotoViewController
            photoViewController.message = self.selectedMessage
            photoViewController.hidesBottomBarWhenPushed = true
            
            //another way to get the message
            //let message = sender as! PFObject
        }
    }
    
    
}

























