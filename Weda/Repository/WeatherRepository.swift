//
//  WeatherRepository.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 25/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import SwiftyJSON

class weatherRepository: WeatherRepositoryProtocol {
    var weatherRemoteService : WeatherService? = WeatherService() //TODO: make this a singleton class
    
    
    func fetchWeatherData(location: String, complete: @escaping (Bool, Any, APIError?) -> ()) {
        //TODO: if local is empty or less than 5, fectch remote, |
        
        if let weatherInstance = weatherRemoteService {
            weatherInstance.fetchWeatherData(location: location) { (status, weatherData, apiError) in
                if status {
                    let weatherArray  = self.getWeatherFromJson(JSON(weatherData))
                    complete(status, weatherArray, apiError)
                }else{
                    complete(status,[weatherData],apiError)
                }
            }
        }
    }
    
    
    func saveWeather(weatherArray: [Weather], complete: @escaping (Bool) -> ()) {
        
    }
    
    
    func deleteOldWeatherData(complete: @escaping (Bool) -> ()) {
        
    }
    
    
    //MARK helper methods
    func getWeatherFromJson(_ jsonData: JSON) ->[Weather]{
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
        return weatherArray
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
}
