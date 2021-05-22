//
//  QuoteTableViewController.swift
//  InspirationalQuotes
//
//  Created by Kurtis Hoang on 5/12/21.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let productID = "com.kurtishoang.premiumquotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self) //whenever a change happens to payment transaction, it will find delegate method
        
        if premiumQuotesPurchased() {
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if premiumQuotesPurchased() {
            return quotesToShow.count
        } else {
            return quotesToShow.count + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath)
        
        if indexPath.row < quotesToShow.count { //apply text via quotesToShow
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor(named: "Color")
            cell.accessoryType = .none
        } else { //else last row will show this
            cell.textLabel?.text = "Get More Quotes!"
            cell.textLabel?.textColor = #colorLiteral(red: 0.1042075977, green: 0.6661138535, blue: 0.7589743733, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count { //get last row
            buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true) //deselect row
    }
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            //can make payments
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            //can't make payments
            print("User can't make payments")
        }
    }
    
    //MARK: - SKPaymentTransactionObserver Delegate methods
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased { //user purchase was successful
                print("Transaction successful")
                SKPaymentQueue.default().finishTransaction(transaction) //end transaction
                showPremiumQuotes()
                
            } else if transaction.transactionState == .failed { //user cancel/failed purchase
                
                if let error = transaction.error { //error
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction) //end transaction
            } else if transaction.transactionState == .restored {
               
                print("Transaction restored")
                SKPaymentQueue.default().finishTransaction(transaction) //end transaction
                showPremiumQuotes()
            }
        }
    }
    
    func showPremiumQuotes() {
        UserDefaults.standard.setValue(true, forKey: productID) //save non-consumable productId has been purchase
        navigationItem.setRightBarButtonItems(nil, animated: true)
        quotesToShow.append(contentsOf: premiumQuotes) //append premiumQuotes
        tableView.reloadData()
    }
    
    func premiumQuotesPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus {
            return true
        } else {
            return false
        }
    }
    
    //Note: This restore function doesn't work with Configuration.storekit since the data is not being saved based on account an account
    @IBAction func restoreButtonPressed(_ sender: UIBarItem) {
        SKPaymentQueue.default().restoreCompletedTransactions() //if successful move to paymentQueue
    }
    
}
