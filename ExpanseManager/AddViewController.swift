//
//  AddViewController.swift
//  ExpanseManager
//
//  Created by Yasin Shamrat on 12/29/19.
//  Copyright © 2019 Yasin Shamrat. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    //    var expense NSManagedObject =
    var isCredit : Bool = true
    @IBOutlet weak var expenseTitleField: UITextField!
    @IBOutlet weak var expenseAmountField: UITextField!
    @IBOutlet weak var isCreditBtnOutlet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        if expenseTitleField.text != "" && expenseAmountField.text != ""{
            
            expenseAmountField.layer.borderWidth = 0
            expenseTitleField.layer.borderWidth = 0
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Expense", in: managedContext)!
            let expense = NSManagedObject(entity: entity, insertInto: managedContext)
            
            expense.setValue(expenseTitleField.text, forKeyPath: "expenseTitle")
            expense.setValue(expenseAmountField.text, forKeyPath: "expenseAmount")
            expense.setValue(isCredit , forKeyPath: "expenseType")
            
            do {
                try managedContext.save()
                expenseAmountField.text = ""
                expenseTitleField.text = ""
                isCreditBtnOutlet.setOn(true, animated: true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else {
            expenseAmountField.layer.borderWidth = 0
            expenseTitleField.layer.borderWidth = 0
            
            if expenseAmountField.text == "" {
                expenseAmountField.layer.borderWidth = 1
                expenseAmountField.layer.borderColor = UIColor.red.cgColor
            }
            if expenseTitleField.text == "" {
                expenseTitleField.layer.borderWidth = 1
                expenseTitleField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        
        
    }
    
    
    @IBAction func expenseType(_ sender: UISwitch) {
        isCredit = sender.isOn
        print(sender.isOn)
    }
    
    
    
}
