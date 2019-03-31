//
//  CategoryTableViewController.swift
//  Realm
//
//  Created by Sourabh Jain on 30/03/19.
//  Copyright © 2019 Sourabh Jain. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category = [CategoryData]()
 

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(category.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = category[indexPath.row].name
        return(cell)
    }
  
    

    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newItem = CategoryData(context: self.context)
            newItem.name = textField.text!
            self.category.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - Data Manipulation Method
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("\(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItem(with request : NSFetchRequest<CategoryData> = CategoryData.fetchRequest()){
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
              category = try context.fetch(request)
        }catch{
            print("Error while fetching\(error)")
        }
        tableView.reloadData()
    }
    
    //MARK:- Table view Delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
}
