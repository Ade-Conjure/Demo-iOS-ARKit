//
//  BusStopARViewController.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import UIKit
import ARKit
import Combine

class BusStopARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak private var sceneView: ARSCNView!
    private var planeNode: SCNNode!
    private var boxes = [BusStopNode]()
    private var arrow: ArrowNode!
    private var texts = [SCNNode]()
    private var anyCancellable = Set<AnyCancellable>()
    private var viewModel = BusStopARViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLighting()
        sceneView.delegate = self
        
        let scene = SCNScene()
        let plane = SCNPlane(width: 1.0, height: 1.0)
        planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        
        sceneView.scene.rootNode.addChildNode(planeNode)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        viewModel.$busRoutes.sink { busRoutes in
            self.boxes = busRoutes.map { self.addBox(busRoute: $0) }
            self.texts = self.boxes.map {
                SCNNode.text(
                    withString: $0.name ?? "",
                    color: .red,
                    opacity: 0.0,
                    shouldLookAtNode: self.sceneView.pointOfView!,
                    addAboveExistingNode: $0)
            }
            
            for node in self.boxes {
                self.sceneView.scene.rootNode.addChildNode(node)
            }
            
            for i in 0..<self.boxes.count {
                self.positionNode(self.boxes[i], basedOnAnchorOf: self.planeNode, withOffset: self.boxes[i].getPoints(relativeTo: busRoutes, on: plane) )
            }
            
            if self.boxes.count >= 2 {
                for i in 0..<self.boxes.count - 1 {
                    let cylinderNode = self.createPath(from: self.boxes[i], to: self.boxes[i + 1])
                    cylinderNode.eulerAngles.x = -.pi / 2
                    self.sceneView.scene.rootNode.addChildNode(cylinderNode)
                }
            }
            guard let usersCoordinates = self.viewModel.usersCoordinates else { return }
            self.arrow = ArrowNode(usersCoordinates: usersCoordinates, sceneView: self.sceneView)
            self.positionNode(self.arrow, basedOnAnchorOf: self.planeNode, withOffset: self.arrow.getPoints(relativeTo: busRoutes, on: plane))
            self.sceneView.scene.rootNode.addChildNode(self.arrow)
        }.store(in: &anyCancellable)
        sceneView.scene = scene
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(location, options: [:])
        for result in hitTestResults {
            if let busStopNode = result.node.parent as? BusStopNode {
                
                for i in boxes where i.shouldShowText == true {
                    i.shouldShowText = false
                    
                    let showingTexts = texts.filter { $0.name == i.name }
                    _ = showingTexts.map {$0.opacity = 0.0}
                }
                
                busStopNode.shouldShowText = true
                let showingTexts = texts.filter {$0.name == busStopNode.name }
                _ = showingTexts.map {$0.opacity = 1}
                viewModel.getArrivalTime(with: busStopNode.busRoute.id)
                viewModel.$arrivalTime.sink { arrivalTime in
                }.store(in: &anyCancellable)
                
            }
        }
    }
    
    func positionNode(_ nodeToBePositioned: SCNNode, basedOnAnchorOf nodeWithAnchor: SCNNode, withOffset offset: CGPoint) {
        let anchorPositionInNodeToBePositioned = nodeToBePositioned.convertPosition(nodeWithAnchor.position, from: nodeWithAnchor.parent)
        let newPosition = CGPoint(x: CGFloat(anchorPositionInNodeToBePositioned.x) + offset.x, y: CGFloat(anchorPositionInNodeToBePositioned.y) + offset.y)
        nodeToBePositioned.position = nodeToBePositioned.convertPosition(SCNVector3(newPosition.x, newPosition.y, 0.0), to: nodeToBePositioned.parent)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        planeNode.position = SCNVector3(planeAnchor.center.x, 0.0, planeAnchor.center.z)
    }
    
    func addBox(busRoute: Route) -> BusStopNode {
        let node = BusStopNode(busRoute: busRoute, sceneView: self.sceneView)
        return node
        
    }
    
    func createPath(from startNode: SCNNode, to endNode: SCNNode) -> SCNNode {
        let distance = startNode.position.distance(to: endNode.position)
        let geometry = SCNCylinder(radius: 0.002, height: CGFloat(distance))
        geometry.firstMaterial?.diffuse.contents = UIColor.green
        
        let pathNode = SCNNode(geometry: geometry)
        
        let midpoint = SCNVector3((startNode.position.x + endNode.position.x) / 2,
                                  (startNode.position.y + endNode.position.y) / 2,
                                  (startNode.position.z + endNode.position.z) / 2)
        
        pathNode.position = midpoint
        startNode.parent?.addChildNode(pathNode)
        
        pathNode.eulerAngles.x = Float.pi / 2
        pathNode.look(at: endNode.position, up: SCNVector3(0, 1, 0), localFront: SCNVector3(0, 0, -1))
        
        return pathNode
    }
}

