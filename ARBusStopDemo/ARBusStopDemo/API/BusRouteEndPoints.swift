//
//  BusRouteEndPoints.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import Foundation

enum BusRouteEndPoints {
    case route(busNumber: String)
}

extension BusRouteEndPoints: Endpoint {
    var baseURL: String {
        return "https://api.tfl.gov.uk"
    }
    
    var path: String {
        switch self {
        case .route(busNumber: let busNumber):
            return "Line/\(busNumber)/" + "Route/Sequence/outbound"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .route(busNumber: _ ):
            return [
                URLQueryItem(name: "app_id", value: Constants.transportForLondonAppID),
                URLQueryItem(name: "app_key", value: Constants.transportForLondonKey)
            ]   
        }
    }
}
