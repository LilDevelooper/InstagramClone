//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by yunus emre vural on 27.11.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,
                          UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirebase()
    }
    
    
    func getDataFromFirebase(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil{
                
                self.alertPop(title: "Error", message: error?.localizedDescription ?? "Error")
                
            }else{
                
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentID = document.documentID
                        
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            
                            self.userEmailArray.append(postedBy)
                            
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            
                            self.userCommentArray.append(postComment)
                            
                            
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            
                            self.likeArray.append(likes)
                            
                            
                        }
                        
                        if let imageURL = document.get("imageUrl") as? String {
                            
                            self.userImageArray.append(imageURL)
                            
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userName.text = userEmailArray[indexPath.row]
        cell.like.text = String(likeArray[indexPath.row])
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.comment.text = userCommentArray[indexPath.row]
        cell.documentID.text = documentIdArray[indexPath.row]
        
        return cell
    }
    
    
    
    func alertPop(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
    
    
    
}
