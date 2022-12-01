//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by yunus emre vural on 24.11.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        if userName.text != "" && password.text != ""{
            
            Auth.auth().signIn(withEmail: userName.text!, password: password.text!) { (authdata, error) in
                if error != nil {
                    
                    self.popAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                    
                }else{
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        }else{
            
            self.popAlert(title: "Error!", message: "Username or Password can't be empty !")
            
        }
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if userName.text != "" && password.text != ""{
            
            Auth.auth().createUser(withEmail: userName.text!, password: password.text!) { (authdata, error) in
                
                if error != nil{
                    
                    self.popAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                    
                }else{
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
                
            }
            
            
        }else{
            
            self.popAlert(title: "Error!", message: "Username or Password can't be empty !")
            
        }
        
    }
    
    func popAlert(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

