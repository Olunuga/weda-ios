//
//  Weather.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
  @objc dynamic var date : Date?
  @objc dynamic var icon : String? = "cloud"
  @objc dynamic var location : String?
  @objc dynamic var temperature : String?
  @objc dynamic var tempHigh : Double = 0.0
  @objc dynamic var tempLow : Double = 0.0
  @objc dynamic var humidity : Double =  0.0
  @objc dynamic var windSpeed : Double = 0.0
  @objc dynamic var weatherDescription : String?
  @objc dynamic var iconDesc: String? = "cloud"
  @objc dynamic var pressure : Double = 0.0
}
