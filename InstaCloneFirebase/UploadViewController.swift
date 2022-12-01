//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by yunus emre vural on 27.11.2022.
//

import UIKit
import PhotosUI
import FirebaseStorage
import Firebase

class UploadViewController: UIViewController,PHPickerViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        
        imageView.addGestureRecognizer(imageTapRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
     
        // The client is responsible for presentation and dismissal
        picker.dismiss (animated: true)
        
        // Get the first item provider from the results
        let itemProvider = results.first?.itemProvider
        
        // Access the UIImage representation for the result
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {  image, error in
                if let image = image as? UIImage {
                    // Do something with the UIImage
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        
    }
    
    @objc func selectImage(){
           
           var config = PHPickerConfiguration()
           config.selectionLimit = 1
           config.filter = .images
           
           let picker = PHPickerViewController(configuration: config)
           
           picker.delegate = self
           
           present(picker, animated: true)
           
       }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let storage = Storage.storage()
        
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("Media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
              
                if error != nil{
                    
                    self.alertPop(title: "Error", message: error?.localizedDescription ?? "Error")
     
                }else{
                    
                    imageReferance.downloadURL { url, error in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReferance : DocumentReference? = nil
                            
                            let firestorePost : [String:Any] =
                            ["imageUrl":imageUrl,"postedBy":Auth.auth().currentUser!.email!,
                             "postComment":self.textField.text!,"date":FieldValue.serverTimestamp(),"likes":0]
                            
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.alertPop(title: "Error", message: error?.localizedDescription ?? "Error")
                                    
                                }else{
                                    
                                    
                                    self.imageView.image = UIImage(named: "SelectImage")
                                    self.textField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func alertPop(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
    
}
