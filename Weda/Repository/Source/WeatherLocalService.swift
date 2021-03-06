//
//  WeatherLocalService.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 25/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherLocalService: WeatherRepositoryProtocol {
    lazy var realm = try! Realm()
    
    func fetchWeatherData(location: String, complete: @escaping (Bool, Any, APIError?) -> ()) {
        let predicate = NSPredicate(format: "location = %@",location)
        let weatherItems = realm.objects(Weather.self).filter(predicate)
        complete(true,Array(weatherItems),nil)
    }
    
    func saveWeather(weatherArray: [Weather]?, complete: @escaping (Bool) -> ()) {
        if let weatherItems = weatherArray {
            do {
                try self.realm.write {
                    realm.add(weatherItems)
                }
                complete(true)
            }catch{
                complete(false)
                print(error)
            }
        }
    }
    
    func deleteOldWeatherData(for location : String, complete: @escaping (Bool) -> ()) {
        do {
            try realm.write {
                let predicate = NSPredicate(format: "location = %@",location)
                let weatherItems = realm.objects(Weather.self).filter(predicate)
            realm.delete(weatherItems)
            complete(true)
            }
        } catch{
            print(error)
            complete(false)
        }
    }
    
}
