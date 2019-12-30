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

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFromCore(row: indexPath.row)
            self.items.remove(at: indexPath.row)
            self.tableView.reloadData()
            
        }
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
    }

}

