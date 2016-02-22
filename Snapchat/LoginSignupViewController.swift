//
//  LoginSignupViewController.swift
//  Snapchat
//
//  Created by Nick on 2016-01-26.
//  Copyright © 2016 Nicholas Ivanecky. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginSignupViewController: PFLogInViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        title = "Snap Mac"
        
        let signUpVC = PFSignUpViewController()
        signUpVC.delegate = self
        self.delegate = self
        
        self.signUpController = signUpVC
        
        //configure the logo
        logInView?.logo = UIImageView(image: UIImage(named: "main_logo")!)
        logInView?.logo?.contentMode = .ScaleAspectFit
        
        signUpVC.signUpView!.logo = UIImageView(image: UIImage(named: "main_logo")!)
        signUpVC.signUpView!.logo?.contentMode = .ScaleAspectFit
        
    }
    
    func showInbox()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func setupUserInstallation() {
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackground()
    }
}

extension LoginSignupViewController : PFSignUpViewControllerDelegate
{
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        setupUserInstallation()
        
        dismissViewControllerAnimated(true, completion: nil)
        showInbox()
    }
}

extension LoginSignupViewController : PFLogInViewControllerDelegate
{
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        setupUserInstallation()
        
        
        showInbox()
    }
    
}





























