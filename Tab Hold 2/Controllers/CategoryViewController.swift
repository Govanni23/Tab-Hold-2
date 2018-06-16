//
//  CategoryViewController.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/15/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var catArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        cell?.textLabel?.text = catArray[indexPath.row].name
        return cell!
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Tab", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Tab", style: .default) { (action) in
            //What happens when it's clicked
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.catArray.append(newCategory)
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            //Placeholder
            alertTextField.placeholder = "Person's Name"
            textField = alertTextField
        }
        
        alert.addAction(action)
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
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    //MARK: - Save methods
    func saveCategory(){
        do{
            try context.save()
        } catch{
            print("Error saving context,-------> \(error)")
        }
        
        tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            catArray = try context.fetch(request)
        } catch{
            print("ERROR fetching data from context -------> \(error)")
        }
    }
    
    
}

