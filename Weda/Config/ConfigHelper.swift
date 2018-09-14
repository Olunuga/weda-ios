//
//  ConfigHelper.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 14/09/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation

class ConfigHelper {
    static let OpenWeatherAPIKeyName = "OpenWeatherMapApiKey"
    static let OpenWeatherBaseUrl = "OpenWeatherBaseUrl"
    
    func valueFor(key keyName:String) -> String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value:String = plist?.object(forKey: keyName) as! String
        return value
    }
}
