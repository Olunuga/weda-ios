//
//  Weather.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation

class Weather {
    var date : Date
    var icon :String
    var temperature : String
    
    init(date: Date, icon: String, temp : String) {
        self.date = date
        self.icon = icon
        self.temperature = temp
    }
}
