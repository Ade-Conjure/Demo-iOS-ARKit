//
//  ArrowNode.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 28/04/2023.
//

import ARKit

class ArrowNode: SCNNode {
    
    let usersCoordinates: Coordinate?
    let sceneView: ARSCNView
    
    init(usersCoordinates: Coordinate, sceneView: ARSCNView) {
        self.usersCoordinates = usersCoordinates
        self.sceneView = sceneView
        super.init()
        
        addChildNode(createNode())
        addTextAboveNode(using: "You are here!")
        eulerAngles.x = -.pi / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func getPoints(relativeTo busRoutes: [Route], on plane: SCNPlane) -> CGPoint {
        let coordinatesArray = busRoutes.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) }
        guard let usersCoordinates = usersCoordinates else { return CGPoint(x: 0.0, y: 0.0)}
        let coordinates = CLLocationCoordinate2D(latitude: usersCoordinates.latitude, longitude: usersCoordinates.longitude)
        return coordinateToCGPoint(coordinatesArray, coordinate: coordinates, in: plane)
    }
    
    private func createNode() -> SCNNode {
        let box = SCNSphere(radius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.magenta
        box.firstMaterial = material
        let boxNode = SCNNode(geometry: box)
        return boxNode
    }
    
    private func addTextAboveNode(using string: String) {
        _ = SCNNode.text(
            withString: string,
            color: .red,
            shouldLookAtNode: sceneView.pointOfView!,
            addAboveExistingNode: self)
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
        
        return CGPoint(x: x + 0.3 , y: y + 0.3)
    }
    
}
