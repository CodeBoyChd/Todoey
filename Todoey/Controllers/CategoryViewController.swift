//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anurag Garg on 05/12/18.
//  Copyright © 2018 U2opia Mobile. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load the categories again
        loadCategories()
    }
    
    
    // MARK : Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "There are no active categories present in DB"
        return cell
    }
    
      // MARK : Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!  TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // using coredata
    // MARK : Data manipulation methods : CRUD
//    func loadItems(request : NSFetchRequest<Category> = Category.fetchRequest()){
//        do{
//            categories = try context.fetch(request)
//        }catch{
//            print("Error while fetching data: \(error)")
//        }
//    }

    // using realm
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
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
            //let newCategory = Category(context: self.context)
            //newCategory.name = alertTextField.text!
            //self.categories.append(newCategory)
            //self.saveData()
            
            // using the realm
            let newCategory = Category()
            newCategory.name = alertTextField.text!
            self.saveCategories(newCategory)
        }
        alert.addTextField { (field) in
            alertTextField = field
            alertTextField.placeholder = "Enter category name"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // saving categories using realm
    func saveCategories(_ category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error while saving in realm \(error)")
        }
        
        // reloading data
        self.tableView.reloadData()
    }
}
