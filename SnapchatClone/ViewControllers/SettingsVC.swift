//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Yurii Sameliuk on 21/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

  
    }
    @IBAction func settingsButton(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignVC", sender: nil)
        } catch {
            let nserror = error as NSError
            fatalError("Sign out Error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
