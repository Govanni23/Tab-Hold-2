//
//  ViewController.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/10/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: UIViewController {
    @IBOutlet var tabsTableView: UITableView?
    @IBOutlet weak var tabHoldersFirstName: UITextView!
    @IBOutlet weak var tabHoldersLastName: UITextView!
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabHoldersFirstName.text = "\(selectedCategory!.firstName)"
        tabHoldersLastName.text = "\(selectedCategory!.lastName)"
        tabsTableView?.rowHeight = 80.0
    }

   
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var nameTextField = UITextField()
        var costTextField = UITextField()
        let alert = UIAlertController(title: "Add New Tab Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens once the user clicks the add item button on the UIAlert
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = nameTextField.text!
                    newItem.cost = Float(costTextField.text!)!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("ERROR saving new items, --------> \(error)")
                }
            }
            
            self.tabsTableView?.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            //Placeholder
            alertTextField.placeholder = "Item Name"
            nameTextField = alertTextField
        }
        alert.addTextField { (alertTextField) in
            //Placeholder
            alertTextField.placeholder = "Cost"
            costTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Save Methods
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tabsTableView?.reloadData()
        
    }
    
    
}
//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tabsTableView?.reloadData()
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tabsTableView?.reloadData()
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

extension TodoListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let itemForDeletion = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    print("ERROR deleting item ------------> \(error)")
                }
                tableView.reloadData()
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
            cell.delegate = self
            if let item = todoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
        
            } else {
                cell.textLabel?.text = "No Items Added"
            }
        
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//            if let item = todoItems?[indexPath.row]{
//                do{
//                    try realm.write {
//                        realm.delete(item)
//                    }
//                } catch {
//                    print("ERROR saving done status --------> \(error)")
//                }
//            }
        
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
        }

}
