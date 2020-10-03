//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Yurii Sameliuk on 21/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInButton(_ sender: UIButton) {
        if passwordText.text != "" && emailText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
        } else {
            self.makeAlert(title: "Error", message: "Username/Password ?" )
            
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if userNameText.text != "" && passwordText.text != "" && emailText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    let firestore = Firestore.firestore()
                    
                    let userDictionary = ["email": self.emailText.text!, "name": self.userNameText.text!] as [String: Any]
                    firestore.collection("User Info").addDocument(data: userDictionary) { (error) in
                        if error == nil {
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Username/Password/Email ?")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

