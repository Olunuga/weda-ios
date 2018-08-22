//
//  WeatherController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
class WeatherViewModel {
    let weatherService : WeatherService
    
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
    
    var updateLoadingStatusClosure : (()->())?
    var reloadDataClosure : (()->())?
    var showAlert : (()->())?
    

   
    init(weatherService : WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }
    
    
    func initFetch(){
        self.isDataLoading = true
        weatherService.fetchWeatherData { (success, weather, error) in
            self.isDataLoading = false
            if let error = error {
                self.alertMessage = error.rawValue
            }else {
                self.weatherArray = weather
            }
        }
    }
    
    func getWeatherModelForCellAt(row position: Int) -> Weather{
        return weatherArray[position]
    }
}
