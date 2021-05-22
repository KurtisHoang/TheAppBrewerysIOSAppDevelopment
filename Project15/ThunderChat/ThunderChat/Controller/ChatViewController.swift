//
//  ChatViewController.swift
//  ThunderChat
//
//  Created by Kurtis Hoang on 4/6/21.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore() //database
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        //use MessageCell.xib, register MessageCell.xib cell identifier as ReuseIdentifier
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        title = K.appName
        navigationItem.hidesBackButton = true //hide back button on this view only
        
        loadMessages()
    }
    
    //load message from firestore
    func loadMessages() {
        
        //access firestore db with collectionName and listen for updates via .addSnapshotListener
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = [] //clear array
            
            if let e = error {
                print("There was an issue retrieving data from firestore, \(e)")
            } else {
                if let snapShotDocuments = querySnapshot?.documents { //querySnapshot.documents contains the firestore data
                    for document in snapShotDocuments {
                        
                        let data = document.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messagebody = data[K.FStore.bodyField] as? String {
                            
                            let newMessage = Message(sender: messageSender, body: messagebody)
                            
                            self.messages.append(newMessage)
                            self.messageTextField.endEditing(true)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData() //reload tableView
                                
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email { //Auth.auth().currentUser gets current User's info
            
            if messageBody == "" {
                return
            }
            
            //add to firebase collectionName
            db.collection(K.FStore.collectionName).addDocument(data:
            [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970 //Date().timeIntervalSince1970 give number of seconds since jan 1, 1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e).")
                } else {
                    print("Successfully saved data.")
                    self.messageTextField.text = ""
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        //sign out of firebase
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true) //pop to root and get rid of all previous views
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
      
    }
}

//MARK: - TableView
//DataSource is reponsible for populating the tableview
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell //as! MessageCell (Type casting) allow for us to cast cell as MessageCell.swift which uses the MessageCell.xib
        
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.leftAvatarImage.isHidden = true
            cell.avatarImage.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColor.lightPurple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColor.purple)
        } else {
            cell.leftAvatarImage.isHidden = false
            cell.avatarImage.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColor.purple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColor.lightPurple)
        }
        
        cell.messageLabel.text = message.body //cell's header text
        return cell
    }
}

