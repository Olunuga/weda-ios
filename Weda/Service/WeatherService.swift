//
//  WeatherListServices.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchWeatherData( complete: @escaping ( _ success: Bool, _ weather: [Weather], _ error: APIError? )->() )
}

class WeatherService: APIServiceProtocol {
    // Simulate a long waiting for fetching
    func fetchWeatherData( complete: @escaping ( _ success: Bool, _ Weather: [Weather], _ error: APIError? )->() ) {
        DispatchQueue.global().async {
            sleep(3)
            var weatherArray = [Weather]()
            for _ in 0 ..< 10 {
                let temperature = arc4random_uniform(10) * 2
                let weather = Weather(date: Date.init(), icon: "Windy", temp : "\(temperature)")
                weatherArray.append(weather)
            }
            complete(true,weatherArray,nil)
        }
    }
}
