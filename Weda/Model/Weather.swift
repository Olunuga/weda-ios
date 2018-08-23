//
//  Weather.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation

struct Weather {
    var date : Date
    var icon :String
    var temperature : String
    var tempHigh : Double?
    var tempLow : Double?
    var humidity : Double?
    var windSpeed : Double?
    var description : String?
    var iconDesc: String?
    var pressure : Double?
    
    init(date: Date, icon: String, temp : String) {
        self.date = date
        self.icon = icon
        self.temperature = temp
    }
}
