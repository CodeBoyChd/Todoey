//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anurag Garg on 05/12/18.
//  Copyright © 2018 U2opia Mobile. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load the categories again
        loadItems()
    }
    
    
    // MARK : Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
      // MARK : Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!  TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK : Data manipulation methods : CRUD
    func loadItems(request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error while fetching data: \(error)")
        }
    }
    
    func saveData(){
        
        do{
            try self.context.save()
        }catch{
            print("Error while saving data: \(error)")
        }
        self.tableView.reloadData()
    }
    
    // MARK : Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            
            // What will happen when user clicks on the add button
            // Add the data to database
            var newCategory = Category(context: self.context)
            newCategory.name = alertTextField.text!
            self.categories.append(newCategory)
            self.saveData()
        }
        alert.addTextField { (field) in
            alertTextField = field
            alertTextField.placeholder = "Enter category name"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
