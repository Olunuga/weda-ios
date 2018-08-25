//
//  WeatherListServices.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

class WeatherService: WeatherRepositoryProtocol {
    let WEATHER_BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "f936b63d575f6aeded7bdb33e0084e1d"
    let BASEIMAGEURL = "http://openweathermap.org/img/w/"
    
    func fetchWeatherData(location : String, complete: @escaping ( _ success: Bool, _ jsonData: Any, _ error: APIError? )->() ) {
        let params : Parameters = ["q":location, "appid":APP_ID]
        Alamofire.request(WEATHER_BASE_URL, method: .get, parameters: params, encoding: URLEncoding.queryString)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                if response.result.isSuccess{
                     complete(true,response.result.value!,nil)
                }else{
                    complete(false,[Weather](),APIError.noNetwork)
                }
        }
    }
    
    func saveWeather(weatherArray: [Weather], complete: @escaping (Bool) -> ()) {
        
    }
    
    func deleteOldWeatherData(complete: @escaping (Bool) -> ()) {
        
    }
}
