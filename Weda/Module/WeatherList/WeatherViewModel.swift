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
        self.location = location
        weatherRespository.fetchWeatherData(location: location!) { (success, data, error) in
            self.isDataLoading = false
            if let error = error {
                self.alertMessage = error.rawValue
            }else {
                let weatherArray = data as! [Weather]
                if let weatherItem = weatherArray.first {
                    if weatherItem.date!.compare(Date()) == ComparisonResult.orderedAscending {
                        if CheckInternet.Connection(){
                            //Get new data if there is internet connection
                            self.weatherRespository.deleteOldWeatherData(for:location!, complete: { (status) in
                                self.initFetch(location: location)
                            })
                        }else{ //Clear the old data and show only recent one.
                           self.weatherArray =  self.removeOldData(from: weatherArray);
                        }
                       
                        
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
        return DateHelper().getFriendlyDate(date: date)
    }
    
    func removeOldData(from weatherArray: [Weather]) -> [Weather]{
      return  weatherArray.filter { (weather) -> Bool in
        let date = weather.date!
        let currentDate = Date()
          return  date.compare(currentDate) == ComparisonResult.orderedDescending 
        }

    }
    
}
