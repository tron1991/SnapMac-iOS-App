//
//  NewMessageTableViewController.swift
//  Snapchat
//
//  Created by Nick on 2016-01-26.
//  Copyright © 2016 Nicholas Ivanecky. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class NewMessageTableViewController: FriendsTableViewController
{
    
    // MARK: - Properties
    
    let cellAccessoryColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    
    private var image: UIImage!
    private var videoFilePath: String!
    private var imagePicker: UIImagePickerController!
    
    private var recipents = [String]()
    private var outgoingUsers = [PFUser]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if imagePicker == nil && image == nil && videoFilePath == nil {
            showCamera()
        }
    }
    
    
    func showCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(imagePicker.sourceType)!
        imagePicker.videoMaximumDuration = 10
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK: - Target Action
    
    @IBAction func cancel()
    {
        imagePicker = nil
        recipents.removeAll()
        image = nil
        videoFilePath = nil
        self.tabBarController?.selectedIndex = 0
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendDidTap (sender: AnyObject)
    {
        if image == nil && videoFilePath.isEmpty {
            print("Oops, you would want to send something to your friend")
        } else {
            setUpMessage()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    //MARK: Helper Methods 
    
    func setUpMessage()
    {
        //fileData, fileName, fileType, senderID, senderName, recipientsIDs
        var fileData: NSData!
        var fileName: String!
        var fileType: String!
        
        if image != nil {
            //this is a photo message
            let resizedImage = self.resizeImage(self.image)
            fileData = UIImagePNGRepresentation(resizedImage)
            fileName = "photo.png"
            fileType = "photo"
        } else {
            //video message
            fileData = NSData(contentsOfFile: videoFilePath)
            fileName = "video.mov"
            fileType = "video"
        }
        
        uploadMessage(fileData, fileName: fileName, fileType: fileType)
    }
    
    func uploadMessage(fileData: NSData, fileName: String, fileType: String)
    {
        //create a new PFFile for our video and photo
        
        //save the PFFile into Parse
        
        //construct a new message
        
        //save message to parse
        
        let messageFile = PFFile(name: fileName, data: fileData)
        
        messageFile?.saveInBackgroundWithBlock( { (success, error) -> Void in
            if error == nil {
                
                let message = PFObject(className: "Messages")
                message["senderName"] = self.currentUser.username
                message["senderId"] = self.currentUser.objectId
                message["recipientIds"] = self.recipents
                message["file"] = messageFile
                message["fileType"] = fileType
                
                message.saveInBackgroundWithBlock( { (success, error) -> Void in
                    if error == nil {
                        //send the msg successfully, let's go back to the inbox
                        
                        //push notification sent to parse
                        
                        let pushQuery = PFInstallation.query()
                        pushQuery?.whereKey("user", containedIn: self.outgoingUsers)
                        let push = PFPush()
                        push.setQuery(pushQuery)
                        
                        let username = PFUser.currentUser()!.username
                        let pushDataDictionary = ["alert" : "New Message from \(username!)", "badge" : "Increment", "sound" : ""]
                        push.setData(pushDataDictionary)
                        push.sendPushInBackground()
                        
                        //done. let's go back to the inbox
                        
                        self.cancel()
                    } else {
                        print (error)
                    }
                    
                })

            } else {
                print(error)
            }
            })
        
        
        
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let recipient = self.friends[indexPath.row]
        
        if cell?.accessoryView == nil {
            //isnt selected yet
            cell?.accessoryView = MSCellAccessory(type: MSCellAccessoryType.FLAT_CHECKMARK, color: self.cellAccessoryColor)
            self.recipents.append(recipient.objectId!)
            self.outgoingUsers.append(recipient)
        } else {
            //it is already selected, let's uncheck it
            cell?.accessoryView = nil
            if let index = recipents.indexOf(recipient.objectId!) {
                self.recipents.removeAtIndex(index)
                self.outgoingUsers.removeAtIndex(index)
                print (recipents)
            }
        }
    }
    
}

extension NewMessageTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        cancel()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            //a photo taken
            self.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        } else {
            //a video shot
            videoFilePath = (info[UIImagePickerControllerMediaURL] as! NSURL).path
            UISaveVideoAtPathToSavedPhotosAlbum(videoFilePath, nil, nil, nil)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - Resize Image

extension NewMessageTableViewController
{
    func resizeImage(originalImage: UIImage) -> UIImage
    {
        let height: CGFloat = 480.0
        let ratio = image.size.width / image.size.height
        let width = height * ratio
        
        let newSize = CGSizeMake(width, height)
        let newRectangle = CGRectMake(0, 0, width, height)
        
        UIGraphicsBeginImageContext(newSize)
        originalImage.drawInRect(newRectangle)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

























