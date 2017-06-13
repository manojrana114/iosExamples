//
//  DataModel.swift
//  AlamofireDemo
//
//  Created by Manoj pratap singh rana on 07/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

import Foundation
import Alamofire

class DataModel {
    
     var _date: Operation?
     var _temp: String?
     var _location: String?
     var _weather: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Portland&appid=a7bbbd5e82c675f805e7ae084f742024")!
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: _date!)
        return (_date != nil) ? "Today, \(dateFormatter.string(from: date))" : "Date Invalid"
    }
    
    var temp: String {
        return _temp ?? "0 °C"
    }
    
    var location: String {
        return _location ?? "Location Invalid"
    }
    
    var weather: String {
        return _weather ?? "Weather Invalid"
    }
}

// Alamofire usage
extension DataModel{
    func downloadData(completed: @escaping ()-> ()) {
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard, let main = dict["main"] as? JSONStandard, let temp = main["temp"] as? Double, let weatherArray = dict["weather"] as? [JSONStandard], let weather = weatherArray[0]["main"] as? String, let name = dict["name"] as? String, let sys = dict["sys"] as? JSONStandard, let country = sys["country"] as? String, let dt = dict["dt"] as? Double {
                
                self._temp = String(format: "%.0f °C", temp - 273.15)
                self._weather = weather
                self._location = "\(name), \(country)"
                self._date = dt
            }
            
            completed()
        })
    }
}


extension DataModel{
    
    func alamofireJSONHandler(){
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            let result = response.result
            result.value as Dictionary<String:AnyObject>
            
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
}


extension DataModel{

    func alamofireHandlerOnCustomQueue(){
    let queue = DispatchQueue.global(qos: .userInitiated)
        
        Alamofire.request("https://httpbin.org/get").validate().responseData(queue: queue) { (response) in
            print(response.data)
            print(response.error)
            print(response.value)
            
        }
        
    }

}
