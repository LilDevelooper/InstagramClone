//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by yunus emre vural on 1.12.2022.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var like: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var documentID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButton(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(like.text!){
        
            let likeStore = ["likes": likeCount + 1] as [String:Any]
            
            fireStoreDatabase.collection("Posts").document(documentID.text!).setData(likeStore, merge: true)
        
        }
        
    }
    
}
