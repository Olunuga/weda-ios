//
//  PresentationHelper.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 08/09/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
class PresentationHelper{
    func formatTemperature(temperature : Double?,_ fullUnit : Bool) -> String {
        var tempFormat = "..."
        if fullUnit {
            tempFormat = "\(Int(temperature!)) ℃"
        }else{
            tempFormat = "\(Int(temperature!)) °"
        }
        return tempFormat
    }
    
    func formatHumidity(humidity : Double?) ->  String {
        let humidityFormat = "\(Int(humidity!))%"
        return humidityFormat
    }
    
    func formatWindSpeed(windSpeed : Double?) -> String {
        let windSpeedFormat = "\(windSpeed!) Km/hr"
        return windSpeedFormat
    }
}
