//
//  BusRoute.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import Foundation

struct BusRoute: Codable {
    var stopPointSequences: [StopPoint]
}

struct StopPoint: Codable {
    var stopPoint: [Route]
}

struct Route: Codable {
    var id: String
    var name: String
    var lat: Double
    var lon: Double
}
