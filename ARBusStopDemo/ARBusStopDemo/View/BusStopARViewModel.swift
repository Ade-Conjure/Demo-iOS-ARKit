//
//  BusStopARViewModel.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import Foundation
import Combine

class BusStopARViewModel: ObservableObject {
    @Published var locationService = LocationService.shared
    @Published var busStops: [BusStop] = []
    @Published var busRoutes: [Route] = []
    @Published var arrivalTime: [ArrivalTime] = []
    @Published var usersCoordinates: Coordinate?
    private let networkManager = NetworkManager()
    private var anyCancellable = Set<AnyCancellable>()
    
    var status: Status = .notDetermined
    var coordinates: Coordinate?
    
    init() {
        locationService.delegate = self
    }
    
    func getBusRoute(for busNumber: String) {
        networkManager.fetchData(endpoint: BusRouteEndPoints.route(busNumber: busNumber))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] (routes: BusRoute) in
                guard let strongSelf = self else { return }
                let stopPoints = routes.stopPointSequences.flatMap { $0.stopPoint }
                strongSelf.busRoutes.append(contentsOf: stopPoints)
            })
            .store(in: &anyCancellable)
    }
    
    func getBusTopData(with coordinates: Coordinate)  {
        networkManager.fetchData(endpoint: BusStopEndpoint.stopPoint(coordinate: coordinates))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self ] (busStops: TravelInformation) in
                guard let lineId = busStops.stopPoints.first?.lines.first?.id else { return }
                self?.getBusRoute(for: lineId)
            }).store(in: &self.anyCancellable)
    }
    
    func getArrivalTime(with stopID: String) {
        networkManager.fetchData(endpoint: BusStopEndpoint.arrivals(busStopID: stopID))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self ] (arrivalTime:  [ArrivalTime]) in
                guard let strong = self else { return }
                strong.arrivalTime = arrivalTime
            }).store(in: &self.anyCancellable)
    }
}

extension BusStopARViewModel: LocationServicesDelegate {
    func getUserAuthorizationStatus(_ status: Status) {
        self.status = status
    }
    
    func getUserCurrentLatLonCoordinates(_ coordinate: Coordinate) {
        getBusTopData(with: coordinate)
        usersCoordinates = (latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
