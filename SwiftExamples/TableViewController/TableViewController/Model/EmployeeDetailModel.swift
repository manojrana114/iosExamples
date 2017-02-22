//
//  EmployeeDetailModel.swift
//  TableViewController
//
//  Created by Manoj Pratap on 22/02/17.
//  Copyright © 2017 learning. All rights reserved.
//

import Foundation

struct EmployeeDetailModel
{
    struct EmployeeDetail
    {
        struct Details{
            let name        : String
            let id          : Int
            let company     : String
            let joiningDate : Date
        }
        
        let nickName : String
        let details : Details
        
        init(<#parameters#>) {
            <#statements#>
        }
    }
    
    var employeeList : Array <EmployeeDetail>{
    
        get{
            var eList = Array <EmployeeDetail>()
            // Read json from file
            
            if let jsonFilePath = Bundle.main.path(forResource: "data", ofType: ".json"){
                if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath)){
                    if let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers){
                        let nickName =
                        
                        
                        var employeeDetail = EmployeeDetail()
                    }
                
                }
                
            }
            
            return eList
        
        }
    }
    

    
    
    
}
