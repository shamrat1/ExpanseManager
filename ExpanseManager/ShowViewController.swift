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
    var debit = 0 , credit = 0,debitCount = 0 , creditCount = 0
    @IBOutlet weak var infoLabel: UILabel!
    var items = [[NSManagedObject]]()
    var creditItems : [NSManagedObject] = []
    var deditItems : [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Expense")
        
        do {
            let allitems = try context.fetch(request)
            
            for item in allitems{
                if item.value(forKey: "expenseType") as! Bool{
                    creditItems.append(item)
                }else{
                    deditItems.append(item)
                }
            }
            items.append(creditItems)
            items.append(self.deditItems)
        } catch {
            print("error: \(error)")
        }
        
        self.calculation()
        infoLabel.text = "Debit: \(debit) & Credit: \(credit - debit)"
        tableView.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = section == 0 ? "Credit" : "Debit"
        return header
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell") as! ShowTableViewCell
        let item = items[indexPath.section][indexPath.row]
        let expenseType = item.value(forKey: "expenseType") as! Bool
        let expenseLabel = (item.value(forKey: "expenseTitle") as! String)
        let expenseAmount = item.value(forKey: "expenseAmount") as! String
        
        cell.expenseAmountLabel.textColor = (expenseType ? .green : .red)
        
        cell.expenseAmountLabel.text = expenseAmount
        cell.expenseTitle.text = expenseLabel
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editButton = UIContextualAction(style: .normal, title: "Edit") { (action, view, success) in
            self.settingAlertNTextField(section: indexPath.section,row: indexPath.row)
            
        }
        
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            
            self.deleteFromCore(row: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [editButton,deleteButton])
    }
    func calculation(){
        debit = 0
        credit = 0
        for i in items{
            for item in i{
                let type = item.value(forKey: "expenseType") as! Bool
                let amount = item.value(forKey: "expenseAmount") as! String
                
                if type {
                    credit += Int(amount)!
                    
                }else {
                    debit += Int(amount)!
                    
                }
            }
        }
    }
    
    func settingAlertNTextField(section: Int , row: Int){
//        print(items[row])
    
        let alert = UIAlertController(title: "Edit Records", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (UITextField) in
            let textField = UITextField
            textField.text = self.items[section][row].value(forKey: "expenseTitle") as? String
            
        }
        alert.addTextField { (UITextField) in
            let textField = UITextField
            textField.text = self.items[section][row].value(forKey: "expenseAmount") as? String
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (UIAlertAction) in
            let value = [
                alert.textFields?[0].text!,
                alert.textFields?[1].text!
            ]
            self.editRecord(section:section,row: row,value: value as! [String])
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func editRecord(section:Int,row: Int, value: [String]) {
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
        let item = self.items[section][row]
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

