//
//  ArrivalTime.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import Foundation

struct ArrivalTime: Codable, Hashable {
    var naptanId: String
    var timeToStation: Int
    var stationName: String
    var lineName: String
    var destinationName: String
    
    var timeInMinutes: String {
        if timeToStation < 60 {
            return "Due"
        }
        return "\(timeToStation / 60) mins"
    }
}
