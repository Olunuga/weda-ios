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
    

    init(weatherService : WeatherService = WeatherService(), weatherRepository : weatherRepository = weatherRepository()) {
        self.weatherService = weatherService
        self.weatherRespository = weatherRepository
    }
    
    
    func initFetch(){
        self.isDataLoading = true
        let location : String? = "Lagos"
        weatherRespository.fetchWeatherData(location: location!) { (success, data, error) in
            self.isDataLoading = false
            if let error = error {
                self.alertMessage = error.rawValue
            }else {
                self.weatherArray = data as! [Weather]
            }
        }
    }
    
    func getWeatherModelForCellAt(row position: Int) -> Weather{
        return weatherArray[position]
    }
}
