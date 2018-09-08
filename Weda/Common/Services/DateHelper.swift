//
//  DateHelper.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 08/09/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import Foundation

class DateHelper {
    func getFriendlyDate(date: Date)->String{
        let day = Calendar.current.component(.day, from: date)
        let today = Calendar.current.component(.day, from: Date())
        let difference = day - today
        
        switch difference {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            let dateFormatter = DateFormatter()
            // US English Locale (en_US)
            dateFormatter.locale = Locale(identifier: "en_GB")
            dateFormatter.setLocalizedDateFormatFromTemplate("Ed")
            return dateFormatter.string(from: date) // Tues, 31
        }
    }
}
