//
//  ViewController.swift
//  ToDoList-PersistingData
//
//  Created by Kurtis Hoang on 4/16/21.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        //happens when selectedCategory get set with a value
        didSet {
            loadItems()
        }
    }
    
    //if using UserDefaults
    //let defaults = UserDefaults.standard
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist") //file path
    
    //get persistentContainer from AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        print(dataFilePath!) //path of file instead of document use library/preference
        
        //loadItems() //load items
        
        //if using UserDefaults
        //set itemArray via the local storage (UserDefaults)
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //get cell using identifier
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none //ternary operator
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //deleting from core data
//        context.delete(itemArray[indexPath.row]) //delete from context, then need to saveItems to update core data
//        itemArray.remove(at: indexPath.row) //delete from itemArray
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //set the opposite
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addToDoPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //alert message
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        //action for alert meesage
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newItem = Item(context: self.context)
                
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                
                self.saveItems() //save Items to Item.plist
                
                //if using UserDefaults
                //self.defaults.set(self.itemArray, forKey: "ToDoListArray") //adds to local storage (UserDefaults) using the key ToDoListArray
                
                self.tableView.reloadData()
            }
            
        }
        
        //creates a textField for alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func saveItems() {
        
        //if using plist to store data
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error encoding item array, \(error)")
//        }
        
        //core data saving
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData() //reload data to update
    }
    
    //request has a default value if no request is passed
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        //if using plist to read data
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//        }
        
        //core data reading
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = request.predicate {
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request) //store in itemArray
        } catch {
            print("Error fetching context, \(error)")
        }
        
        tableView.reloadData() //reload data to update
    }
}

//MARK: - searchBar Methods

//searchBar control+leftclick on yellow ToDoList in main storyboard for delegate
extension ToDoListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest() //fetch all result in DataModel.sqlite via Item model
        
        //when searchBar.text == ""
        if(searchBar.text?.count != 0)
        {
            //[cd] = diacritic sensitive
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //add predicate and find title using searchBar.text
        
            let sortDescripter = NSSortDescriptor(key: "title", ascending: true) //sorts
            
            request.sortDescriptors = [sortDescripter]
            
            loadItems(with: request)
        }
        
        searchBar.resignFirstResponder() //searchBar not selected anymore
    }

    //when text updates
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //when searchBar.text == ""
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //searchBar not selected anymore
            }
        }
    }
}
