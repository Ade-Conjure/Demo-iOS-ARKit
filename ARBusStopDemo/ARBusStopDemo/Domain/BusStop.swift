//
//  BusStop.swift
//  BusTimes-MVVM
//
//  Created by Ade Adegoke on 05/02/2023.
//

import Foundation

struct TravelInformation: Codable {
    var stopPoints: [BusStop]
}

struct BusStop: Codable, Hashable  {
    var id: String
    var naptanId: String
    var commonName: String
    var distance: Double
    var lat: Double
    var lon: Double
    var lines: [Lines]
}

extension BusStop: Identifiable {
    var identifier: String {
        return id
    }
}

struct Lines: Codable, Hashable {
    let id: String
    var name: String
}

struct BusArrivalData: Codable {
    var stopPoints: [ArrivalTime]
}


