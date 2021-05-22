//
//  CategoryTableViewController.swift
//  ToDoList-PersistingData
//
//  Created by Kurtis Hoang on 4/21/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var category: Results<Category>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.separatorStyle = .none //removes lines between each cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar  else {fatalError("Navigation Controller does not exist")}
        
        //change large title text color based on navbar backgroundColor
        let contrastColor = ContrastColorOf(navBar.backgroundColor!, returnFlat: true)
        let colorAttribute = [NSAttributedString.Key.foregroundColor: contrastColor]
        navBar.largeTitleTextAttributes = colorAttribute
        addButton.tintColor = ContrastColorOf(navBar.backgroundColor!, returnFlat: true)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //get cell of super class
        
        if let safeCategory = category?[indexPath.row] {
            cell.textLabel?.text = safeCategory.name
            cell.textLabel?.textColor = ContrastColorOf(HexColor(safeCategory.backgroundColor)!, returnFlat: true)
            cell.backgroundColor = HexColor(safeCategory.backgroundColor) //Using Chameleon framework, Without Chameleon: UIColor(hexString: "")
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true) //deselect row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    //MARK: - Model Manipulation Methods
    func saveCategory(with category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category to realm, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {

        category = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = category?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category to realm, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.dateCreated = Date()
                newCategory.backgroundColor = UIColor.randomFlat().hexValue()
                self.saveCategory(with: newCategory)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension CategoryTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count != 0 {
            category = category?.filter("name CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
            tableView.reloadData()
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadCategory()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
