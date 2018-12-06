//
//  ViewController.swift
//  Todoey
//
//  Created by Anurag Garg on 30/11/18.
//  Copyright © 2018 U2opia Mobile. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        
        didSet{
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    // create a data file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataFilePath)
        //searchBarOutlet.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
        //            itemArray = items
        //        }
    }
    
    // MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    // MARK table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(itemArray[indexPath.row])")
        
        // deleting the item coredata
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // to deselect the item after it gets clicked
        tableView.deselectRow(at: indexPath, animated: true)
        
        // save the done data (checked) when clicked
        //saveItems()
        
        // to show the checkmark as accessary
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //using realm
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error while updating the values \(error)")
            }
        }
        tableView.reloadData()
    }
    
    // MARK : Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            // what will happen whenever user clicks the ADD item on our UI Alert
            //            let newItem = Item(context: self.context)
            //            newItem.title = textField.text!
            //            newItem.done = false
            //            newItem.parentCategory = self.selectedCategory
            //            self.itemArray.append(newItem)
            //
            //            // save in the database
            //            // saving in user defaults
            //            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            //            self.saveItems()
            
            // using realm
            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.date = Date()
                        currentCategory.items.append(item)
                    }
                }catch{
                    print("Error while saving the item")
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        //        let encoder = PropertyListEncoder()
        //
        //        do{
        //            let data = try encoder.encode(self.itemArray)
        //            try data.write(to : self.dataFilePath!)
        //        } catch{
        //            print("Error encoding item array ")
        //        }
        
        // using coredata
        do{
            try context.save()
        }catch{
            print("Error saving the context: \(error)")
        }
        
        // reloading the data
        self.tableView.reloadData()
    }
    
    //    func loadItems(_ request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
    //        if let data = try? Data(contentsOf: dataFilePath!){
    //            let decoder = PropertyListDecoder()
    //
    //            do{
    //                itemArray = try decoder.decode([Item].self, from: data)
    //            }catch{
    //                print("Error while decoding")
    //            }
    //        }
    
    // only those items whose category has been selected
    //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //
    //        if let additionalPredicate = predicate {
    //         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
    //        }else{
    //         request.predicate = categoryPredicate
    //        }
    //
    //        do {
    //            itemArray = try context.fetch(request)
    //        } catch {
    //            print("Error while fecthing the items: \(error)")
    //        }
    
    
    //tableView.reloadData()
    //    }
    
    // using realm
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

// MARK Search bar methods
extension TodoListViewController : UISearchBarDelegate{


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // using coredata
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        //let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        //request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        //loadItems(request, predicate: predicate)
        
        // using realm
        todoItems = todoItems?.filter("title contains %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            // to remove the keyboard and hide the blinking of cursor
            // this has to be done on the main queue but in background thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
