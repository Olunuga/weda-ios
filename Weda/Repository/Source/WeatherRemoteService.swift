//
//  WeatherListServices.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import Alamofire
import Keys

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

class WeatherService: WeatherRepositoryProtocol {
    let configHelper = ConfigHelper()
   
    func fetchWeatherData(location : String, complete: @escaping ( _ success: Bool, _ jsonData: Any, _ error: APIError? )->() ) {
        let WEATHER_BASE_URL = configHelper.valueFor(key: ConfigHelper.OpenWeatherBaseUrl)
        let APP_ID = ConfigHelper().valueFor(key: ConfigHelper.OpenWeatherAPIKeyName)
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
    
    func saveWeather(weatherArray: [Weather]?, complete: @escaping (Bool) -> ()) {
        
    }
    
    func deleteOldWeatherData(for location :String, complete: @escaping (Bool) -> ()) {
        
    }
}
