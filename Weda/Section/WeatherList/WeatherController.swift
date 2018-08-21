//
//  WeatherController.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
class WeatherController {
    var total : Int
    
    init(total: Int) {
        self.total = total
    }
    
    func getWeather()->[Weather]{
        var weatherArray = [Weather]()
        for _ in 0 ..< total {
            let temperature = arc4random_uniform(10) * 2
            let weather = Weather(date: Date.init(), icon: "Windy", temp : "\(temperature)")
            weatherArray.append(weather)
        }
        return weatherArray
    }
}
