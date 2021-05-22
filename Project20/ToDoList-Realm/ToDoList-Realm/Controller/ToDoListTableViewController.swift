//
//  ViewController.swift
//  ToDoList-PersistingData
//
//  Created by Kurtis Hoang on 4/16/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListTableViewController: SwipeTableViewController {
    
    var items: Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var selectedCategory: Category? {
        //happens when selectedCategory get set with a value
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.backgroundColor {
            
            title = selectedCategory!.name //change navBar title to Category
            
            //get navbar
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
            
            //change background color based on selected Category
            navBar.backgroundColor = HexColor(colorHex)
            navBar.tintColor = ContrastColorOf(navBar.backgroundColor!, returnFlat: true)
            searchBar.tintColor = HexColor(colorHex)
            addButton.tintColor = ContrastColorOf(navBar.backgroundColor!, returnFlat: true)
            
            //change large title text color based on navbar backgroundColor
            let contrastColor = ContrastColorOf(navBar.backgroundColor!, returnFlat: true)
            let colorAttribute = [NSAttributedString.Key.foregroundColor: contrastColor]
            navBar.largeTitleTextAttributes = colorAttribute
        }
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            
            //Using Chameleon Framework, without Chameleon: UIColor(hexString: "")
            if let color = HexColor(selectedCategory!.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items!.count)) { //darken each cell based on the cell location in the tableview
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true) //Using Chameleon Framework without Chameleon: cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
                cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true) //change color of accessoryType based on cell background color
            }
            
            cell.accessoryType = item.done ? .checkmark : .none //ternary operator
        }

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                //update
                try self.realm.write {
                    item.done = !item.done
                }
                
                
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - Add New Items
    @IBAction func addToDoPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //alert message
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        //action for alert meesage
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem) //append to Category items
                        }
                    } catch {
                        print("Error Saving item to realm, \(error)")
                    }
                }
                
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
    
    //request has a default value if no request is passed
    func loadItems() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData() //reload data to update
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}

//MARK: - searchBar Methods

//searchBar control+leftclick on yellow ToDoList in main storyboard for delegate
extension ToDoListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //when searchBar.text == ""
        if(searchBar.text?.count != 0)
        {
            items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
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
