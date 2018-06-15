//
//  ViewController.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/10/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UISearchBarDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadItems()
        
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //Mark - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //Mark - This deletes the items
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        self.saveItems()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add New Tab", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens once the user clicks the add item button on the UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            //Placeholder
            alertTextField.placeholder = "Person's Name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark - Data Save Methods
    func saveItems(){
        
        do{
            try context.save()
        } catch{
           print("Error saving context,-------> \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){

        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
     itemArray = try context.fetch(request)
        } catch{
            print("ERROR fetching data from context -------> \(error)")
        }
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        <#code#>
//    }
    
}

