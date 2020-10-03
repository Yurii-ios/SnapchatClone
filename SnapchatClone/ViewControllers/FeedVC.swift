//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Yurii Sameliuk on 21/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    
    var snapArray = [Snap]()
    
    var chosenSnap: Snap?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        getSnapsFromFirebase()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func getSnapsFromFirebase() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {
                                    // wremennaja metka w 24 4asa
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24  {
                                            //delete
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                                print("error to delete ")
                                                
                                            }
                                            }else {
                                            // timeleft -> snapvc
                                            let snap = Snap(userName: username, imageUrl: imageUrlArray, date: date.dateValue(), timeLeft: 24 - difference)
                                            self.snapArray.append(snap)
                                        }
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getUserInfo() {
        fireStoreDatabase.collection("User Info").whereField("email", isEqualTo: Auth.auth().currentUser!.email).getDocuments { (snapshot, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let userName = document.get("name") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = userName
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userNameLabel.text = snapArray[indexPath.row].userName
        // daet nam doztyp k perwomy elementy image w masiwe w daze dannux
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrl[0]), completed: nil)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
