//
//  CategoryViewController.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/15/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategories()
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"

        return cell
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Tab", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Tab", style: .default) { (action) in
            //What happens when it's clicked
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)

        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            //Placeholder
            alertTextField.placeholder = "Person's Name"
            textField = alertTextField
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
    
    override func updateModel(at indexPath: IndexPath){
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("ERROR deleting category -----------> \(error)")
            }
        }
        
    }
    
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













