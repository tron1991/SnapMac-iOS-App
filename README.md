#SnapMac-iOS-App

##Intro & Goal
The goal for the Snap Mac app is to build a community of McMasterU students exchanging pictures and videos. Students will benefit by being able to send as much content without the need of saving pictures or videos on their phones. The application is simpler than Snapchat with a focus on messaging first.

###Who’s it for?
1.	University Students – students in McMaster University can experience the community and share local content around them.

###Why build it?
1.	Building my own social network with inspiration from Snapchat
2.	Develop a full-stack iOS App using Parse Framework (main data storage)

##Video Preview
![screencast](http://g.recordit.co/AZakhNjxel.gif)

##Mockup Designs

![Screen](https://raw.githubusercontent.com/tron1991/Weather-iOS-watchOS-App/master/Wireframes/WeatherAppScreenshots/4-inch%20(iPhone%205)%20-%20Screenshot%201.jpg)

![Screen](https://raw.githubusercontent.com/tron1991/Weather-iOS-watchOS-App/master/Wireframes/AppleWatch.png)

## What is it?

##Login View Controller
This controller appears when the app is first loaded if the user has not logged in. The user would have the option to login with existing credentials (username and password), they will also have the option to create a login if they haven’t.

##Create New User View Controller
This view controller appears when a user has hit the “Create account” button on the Login View Controller page. We ask the user for username, email, and password. Once, the user completes the profile, he is shown the Inbox View Controller.

##Inbox View Controller
This view is presented every time the user opens the app. New messages from existing friends will be sent here. To view a message, user taps a TableViewCell to view the picture message or video message. After the interaction, the message disappears. Push notifications are placed above the Inbox icon in the Tab Menu Bar. 

##Camera View Controller
The view is presented when the tab bar Camera icon is pressed. The standard iOS camera roll will allow the user to take a picture or video and be able to send to your existing friends.

##Friends View Controller
A user can see the total number of friends in this view controller. You have the ability to add and remove friends by tapping the edit button.

##Edit View Controller
In this view you see the total number of friends in the application, you have the ability to add friends or remove them from your list. 

##Push Notifications
Users receive push notifications of the app if they allow them at the start of the app. 

##Registration
Registration is required to use the app. All data will be stored in Parse.

## Installation

Run the Project Files in your local Xcode 7.0 and iOS 9.0 or greater

## Dependencies

Alamofire, Parse

## TODO

Create better friends management system, better camera UI functionality, migration to AWS since Parse is shutting down.

## Creator

Nicholas Ivanecky ([@ivantr0n](http://twitter.com/ivantr0n)), To visit all my works visit ([www.ivantron.com](http://www.ivantron.com))




