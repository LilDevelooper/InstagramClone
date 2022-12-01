//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by yunus emre vural on 27.11.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    

    @IBAction func logoutButton(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("error")
        }
        
    }
    

}
