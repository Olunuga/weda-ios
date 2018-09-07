//
//  WeatherController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherViewModel {
    let weatherService : WeatherService
    let weatherRespository :weatherRepository
    var location : String?  = nil
    
    var isDataLoading : Bool  = false {
        didSet{
            self.updateLoadingStatusClosure?()
        }
    }
    
    var weatherArray : [Weather] =  [Weather]() {
        didSet {
            self.reloadDataClosure?()
        }
    }
    
    var alertMessage : String? {
        didSet{
            self.showAlert?()
        }
    }
    
    var dataCount : Int {
        return weatherArray.count
    }
    
    var noData : Bool? {
        didSet {
            self.isDataAvailable?()
        }
    }
    
    var updateLoadingStatusClosure : (()->())?
    var reloadDataClosure : (()->())?
    var showAlert : (()->())?
    var isDataAvailable : (()->())?
    
    
    init(weatherService : WeatherService = WeatherService(), weatherRepository : weatherRepository = weatherRepository()) {
        self.weatherService = weatherService
        self.weatherRespository = weatherRepository
    }
    
    
    func initFetch(location: String?){
        self.isDataLoading = true
        //let location : String? = "Lagos"
        self.location = location
        weatherRespository.fetchWeatherData(location: location!) { (success, data, error) in
            self.isDataLoading = false
            if let error = error {
                self.alertMessage = error.rawValue
            }else {
                let weatherArray = data as! [Weather]
                if let weatherItem = weatherArray.first {
                    if weatherItem.date!.compare(Date()) == ComparisonResult.orderedAscending {
                        self.weatherRespository.deleteOldWeatherData(complete: { (status) in
                            self.initFetch(location: location)
                        })
                        
                    }else{
                        self.weatherArray = data as! [Weather]
                    }
                }
                
            }
        }
    }
    
    func getWeatherModelForCellAt(row position: Int) -> Weather{
        return weatherArray[position]
    }
    
    func getFriendlyDate(date: Date)->String{
        let day = Calendar.current.component(.day, from: date)
        let today = Calendar.current.component(.day, from: Date())
        let difference = day - today
        
        switch difference {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            let dateFormatter = DateFormatter()
            // US English Locale (en_US)
            dateFormatter.locale = Locale(identifier: "en_GB")
            dateFormatter.setLocalizedDateFormatFromTemplate("Ed")
            return dateFormatter.string(from: date) // Tues, 31
        }
    }
}
