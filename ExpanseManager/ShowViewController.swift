//
//  ViewController.swift
//  ExpanseManager
//
//  Created by Yasin Shamrat on 12/29/19.
//  Copyright © 2019 Yasin Shamrat. All rights reserved.
//

import UIKit
import CoreData

class ShowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var infoLabel: UILabel!
    var items : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Expense")
        
        do {
            try items = context.fetch(request)
//            print(items)
        } catch {
            print("error: \(error)")
        }
//        infoLabel.text = "Debit: \(debit) & Credit: \(credit)"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell") as! ShowTableViewCell
        let item = items[indexPath.row]
        let expenseLabel = (item.value(forKey: "expenseTitle") as! String)
         let expenseAmount = item.value(forKey: "expenseAmount") as! String
//        let expenseType = item.value(forKey: "expenseType") as! Bool
        
//        if expenseType {
//            credit += Double(expenseAmount)!
////            cell.backgroundColor = .red
//        }else {
//            debit += Double(expenseAmount)!
////            cell.backgroundColor = .green
//        }
        cell.expenseAmountLabel.text = expenseAmount
        cell.expenseTitle.text = expenseLabel
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editButton = UIContextualAction(style: .normal, title: "Edit") { (action, view, success) in
            self.settingAlertNTextField(row: indexPath.row)
            
        }
        
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            
            self.deleteFromCore(row: indexPath.row)
            
        }
        
        return UISwipeActionsConfiguration(actions: [editButton,deleteButton])
    }
    func settingAlertNTextField(row: Int){
        print(items[row])
    
        let alert = UIAlertController(title: "Edit Records", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (UITextField) in
            let textField = UITextField
            textField.text = self.items[row].value(forKey: "expenseTitle") as? String
            
        }
        alert.addTextField { (UITextField) in
            let textField = UITextField
            textField.text = self.items[row].value(forKey: "expenseAmount") as? String
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (UIAlertAction) in
            let value = [
                alert.textFields?[0].text!,
                alert.textFields?[1].text!
            ]
            self.editRecord(row: row,value: value as! [String])
        }))
        present(alert, animated: true, completion: nil)
        
    }
    func editRecord(row: Int, value: [String]) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Expense")

        do {
            let data = try context.fetch(request)
            let editData = data[row] as NSManagedObject
            editData.setValue(value[0], forKey: "expenseTitle")
            editData.setValue(value[1], forKey: "expenseAmount")
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch  {
            print(error)
        }
        let item = self.items[row]
        item.setValue(value[0], forKey: "expenseTitle")
        item.setValue(value[1], forKey: "expenseAmount")
        self.tableView.reloadData()
    }
    func deleteFromCore(row: Int){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Expense")
        
        do {
            let data = try context.fetch(request)
            let deleteData = data[row] as NSManagedObject
            context.delete(deleteData)
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch  {
            print(error)
        }
        self.items.remove(at: row)
        self.tableView.reloadData()
    }
    

}

