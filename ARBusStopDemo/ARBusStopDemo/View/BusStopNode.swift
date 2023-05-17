//
//  BusStopNode.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import ARKit

class BusStopNode: SCNNode {
    let busRoute: Route
    let sceneView: ARSCNView
    var shouldShowText = false

    init(busRoute: Route, sceneView: ARSCNView) {
        self.busRoute = busRoute
        self.sceneView = sceneView
        super.init()
        
        addChildNode(createNode())
        self.name = busRoute.name
        eulerAngles.x = -.pi / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func getPoints(relativeTo busRoutes: [Route], on plane: SCNPlane) -> CGPoint {
        let coordinates = busRoutes.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) }
        let selfCoordinates = CLLocationCoordinate2D(latitude: busRoute.lat, longitude: busRoute.lon)
        return coordinateToCGPoint(coordinates, coordinate: selfCoordinates, in: plane)
    }
    
    private func createNode() -> SCNNode {
        let box = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        box.firstMaterial = material
        let boxNode = SCNNode(geometry: box)
        
        return boxNode
    }
    

    private func coordinateToCGPoint(_ coordinatesArray: [CLLocationCoordinate2D], coordinate: CLLocationCoordinate2D, in plane: SCNPlane) -> CGPoint {
        let minLat = coordinatesArray.map { $0.latitude }.min() ?? 0
        let maxLat = coordinatesArray.map { $0.latitude }.max() ?? 0
        let minLon = coordinatesArray.map { $0.longitude }.min() ?? 0
        let maxLon = coordinatesArray.map { $0.longitude }.max() ?? 0

        let latRatio = CGFloat((coordinate.latitude - minLat) / (maxLat - minLat))
        let lonRatio = CGFloat((coordinate.longitude - minLon) / (maxLon - minLon))

        let x = plane.width * lonRatio
        let y = plane.height * (1 - latRatio)

        return CGPoint(x: x, y: y)
    }

    
}

