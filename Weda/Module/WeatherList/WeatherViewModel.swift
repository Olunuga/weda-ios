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
        let location : String? = "Lagos"
        weatherService.fetchWeatherData(location: location!) { (success, data, error) in
            self.isDataLoading = false
            if let error = error {
                self.alertMessage = error.rawValue
            }else {
                self.getWeatherFromJson(JSON(data))
            }
        }
    }
    
    func getWeatherFromJson(_ jsonData: JSON){
        var weatherArray : [Weather] = [Weather]()
        for (_,subJson):(String, JSON) in jsonData["list"] {
            let date = subJson["dt"].doubleValue
            let temperature = subJson["main"]["temp"].doubleValue
            let tempHigh = subJson["main"]["temp_max"].doubleValue
            let tempLow = subJson["main"]["temp_min"].doubleValue
            let hum = subJson["main"]["humidity"].doubleValue
            let windSpeed = subJson["wind"]["speed"].doubleValue
            let description = subJson["weather"][0]["description"].stringValue
            let iconDesc : String = subJson["weather"][0]["icon"].stringValue
            let pressure = subJson["main"]["pressure"].doubleValue
            
            let dateValue : Date = Date(timeIntervalSince1970: date)
                var weather : Weather = Weather()
                weather.date = dateValue
                weather.icon = "cloud"
                weather.temperature = "\(Int(temperature - 271.5))"
                weather.tempHigh = tempHigh
                weather.tempLow = tempLow
                weather.description = description
                weather.pressure = pressure
                weather.windSpeed = windSpeed
                weather.humidity = hum
                weather.iconDesc = iconDesc
            
            if !isDateRepeated(weatherArray: weatherArray, date: dateValue){
                 weatherArray.append(weather)
            }
        }
        self.weatherArray = weatherArray
    }
    
    
    func isDateRepeated(weatherArray : [Weather], date: Date) -> Bool{
        for weather in weatherArray {
            print(Calendar.current.component(.weekday, from: weather.date!))
            if Calendar.current.component(.weekday, from: weather.date!) == Calendar.current.component(.weekday, from: date){
                return true
            }
        }
        return false
    }
    
    func getWeatherModelForCellAt(row position: Int) -> Weather{
        return weatherArray[position]
    }
}
