//
//  WeatherRepositoryProtocol.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 25/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeatherData( location: String, complete: @escaping (_ status: Bool,_ weatherArray:Any,_ error: APIError? )->() )
    func saveWeather(weatherArray : [Weather]?, complete: @escaping (_ status : Bool) ->())
    func deleteOldWeatherData(complete: @escaping (_ status : Bool) ->())
}
