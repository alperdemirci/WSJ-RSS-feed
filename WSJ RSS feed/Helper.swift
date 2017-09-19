//
//  Helper.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/18/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import Foundation
//import UIKit

class Helper: NSObject {
    //MARK: - Date And Time Display
    func dateAndTime() -> String {
        let todayName = Date().dayOfWeek()!
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        let todayDate = formatter.string(from: currentDateTime)
        return (todayName + ", " + todayDate)
    }
}

// extention for Date to return the name of the date fir navbar subtitle
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
