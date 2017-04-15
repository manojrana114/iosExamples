//
//  CoreDataViewController.swift
//  CoreDataDemo
//
//  Created by Manoj pratap singh rana on 10/04/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit
import CoreData
class CoreDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        insertCompany()
        InsertEmployee()
        fetchrecords()
    }

    
    func insertCompany(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context) as? Company{
            company.name = "Impetus"
            company.address = "Noida"
            context.perform {
                do{
                   try context.save()

                }catch(let error){
                    print(error)
                }
            }
        
        }
    
    }

    func InsertEmployee(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as? Employee
        employee?.name = "Manoj"
        employee?.id = 2445
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context) as? Company
        company?.name = "Impetus"
        company?.address = "Noida"
        company?.employees = [employee!]
        employee?.company = company
        context.perform {
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
    }
    
    //Querying database
    func fetchrecords(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        context.perform {
            do{
                let fetchedCompany = try context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>

                print(fetchedCompany)
            }catch{
            fatalError("error occured \(error)")
            }
        }
        
    }
    

}
