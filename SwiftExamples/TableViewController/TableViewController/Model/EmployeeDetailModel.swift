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
    var employeeList = EmployeeDetailModel.createEmployeeList()

    struct EmployeeDetail
    {
        struct Details
        {
            let name        : String
            let id          : Int
            let company     : String
            //let joiningDate : Date
        }
        
        let nickName : String
        let details : Details
        
        init?(jsonDict : Dictionary<String, Any>)
        {
            guard
                let nickName    = jsonDict["nickName"] as? String,
                let details     = jsonDict["details"] as? Dictionary<String,Any>,
                let name        = details["name"] as? String,
                let id          = details["id"] as? Int,
                let company     = details["companyName"] as? String
                //let joiningDate = details["joiningDate"] as? Date
                else{
                    return nil
            }
            
            self.nickName = nickName
            self.details = Details(name: name, id: id, company: company)
        }
    }
    
    
    
    
    static func createEmployeeList() ->Array <EmployeeDetail>
    {
        
        var eList = Array <EmployeeDetail>()
        // Read json from file
        
        if let jsonFilePath = Bundle.main.path(forResource: "data", ofType: ".json")
        {
            //try to get json data
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath))
            {
                //try to get json resulr
                if let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Dictionary<String, Any>]
                {
                    
                    for obj in jsonResult!
                    {
                        if let employeeDetails = EmployeeDetail(jsonDict: obj)
                        {
                            eList.append(employeeDetails)
                        }
                    }
                }
                
            }
            
        }
        
        return eList
    }
    
}
