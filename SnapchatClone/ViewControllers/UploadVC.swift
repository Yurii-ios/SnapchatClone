//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Yurii Sameliuk on 21/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageView.isUserInteractionEnabled = true
        let imageTaprecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImageSelector))
        uploadImageView.addGestureRecognizer(imageTaprecognizer)
        
        
    }
    
    @objc func tapImageSelector() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        // storage
        let storage = Storage.storage()
        
        let storegeReference = storage.reference()
        
        let mediafolder = storegeReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediafolder.child("\(uuid).jpeg")
            
            let taskreference = imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            // firestore
                            let firestore = Firestore.firestore()
                            // priwjazuwaem razdel s foto k konkretnomy polzowately
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                if error != nil {
                                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                } else {
                                    if snapshot?.isEmpty != true && snapshot != nil {
                                        
                                        for document in snapshot!.documents {
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray": imageUrlArray] as [String: Any]
                                                firestore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { (error) in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "select")
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                    } else {
                                        let snapDictionary = ["imageUrlArray": [imageUrl!], "snapOwner": UserSingleton.sharedUserInfo.username, "date": FieldValue.serverTimestamp()] as [String: Any]
                                        // sozdanie razdela w baze
                                        firestore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                            if error != nil {
                                                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                                
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(named: "select")
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                    }
                }
                
            }
            taskreference.observe(StorageTaskStatus.progress) { (snapshot) in
                guard let progress = snapshot.progress?.fractionCompleted else {return}
                print("\(progress) complited")
                self.progressBar.progress = Float(progress)
            }
        }
        
        
    }
    
}
