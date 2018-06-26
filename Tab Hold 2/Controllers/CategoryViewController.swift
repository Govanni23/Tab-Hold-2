//
//  CategoryViewController.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/15/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
       loadCategories()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 0
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fullName = "\(String(describing: categories![indexPath.row].firstName)) \(String(describing: categories![indexPath.row].lastName))"
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = fullName
        cell.delegate = self
        return cell
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var firstNameTextField = UITextField()
        var lastNameTextField = UITextField()
        let alert = UIAlertController(title: "Add New Tab", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Tab", style: .default) { (action) in
            //What happens when it's clicked
            
            let newCategory = Category()
            newCategory.firstName = firstNameTextField.text!
            newCategory.lastName = lastNameTextField.text!
            self.save(category: newCategory)

        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertFirstNameTextField) in
            //Placeholder
            alertFirstNameTextField.placeholder = "Person's First Name"
            firstNameTextField = alertFirstNameTextField
        }
        alert.addTextField { (alertLastNameTextField) in
            alertLastNameTextField.placeholder = "Person's Last Name"
            lastNameTextField = alertLastNameTextField
        }
        
        present(alert, animated: true, completion: nil )
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //context.delete(catArray[indexPath.row])
        //catArray.remove(at: indexPath.row)
        //self.saveCategory()
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Save methods
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("Error saving context,-------> \(error)")
        }
        
        tableView.reloadData()
    }
        func loadCategories(){
            categories =  realm.objects(Category.self)
            tableView.reloadData()
        }
    
    
}

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                       self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("ERROR deleting category ------------> \(error)")
                }
             tableView.reloadData()
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
}
