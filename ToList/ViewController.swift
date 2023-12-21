//
//  ViewController.swift
//  ToList
//
//  Created by Fatih on 20.12.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [ToDoListItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Task", message: "Add New To Do", preferredStyle: .alert)
        
        alert.addTextField { textField in textField.placeholder = "Enter task name"
            
        }
        
        let addButton = UIAlertAction(title: "Add", style: .default) { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self.createItem(name: text)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: ----COREDATA VERİ OLUŞTIRMA-SİLME-KAYDETME-GÜNCELLEME
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        } catch {
            print("error geAllItems")
        }
    }
    func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAd = Date()
        do {
            try context.save()
            getAllItems()
        } catch {
            print("error createItem")
        }
        
    }
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("error deleteItem")
        }
    }
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
        } catch {
            print("error updateItem")
        }
    }
    
    
}

//MARK: ----TABLEVİEW ACTİON----

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
}

//MARK: ----EKLEDİĞİM YAPILACAKLARI TIKLADIĞIMDA SİLME----

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectItem = models[indexPath.row]
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            self.deleteItem(item: selectItem)
            self.getAllItems()
        }
      
        alert.addAction(deleteAction)
        alert.addAction(cancelAlert)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: ----- SEARCHBAR ARAMA İŞLEVİ-----

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(with: searchText)
    }
    func filterItems(with searchText: String) {
        if searchText.isEmpty {
            getAllItems()
        } else {
            let pretica = NSPredicate(format: "name CONTAINS[CD] %@", searchText)
            let fetchRequest: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()
            fetchRequest.predicate = pretica
            
            do {
                models = try context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    self.table.reloadData()

                }
                
                
            } catch {
                print(error)
            }
        }
        
    }
    
    //MARK: ---- KLAVYE OTOMATİK KAPATMA----
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()//KLAVYE KAPAT
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterItems(with: "")
        searchBar.resignFirstResponder()//KLAVYE KAPAT
    }
}

