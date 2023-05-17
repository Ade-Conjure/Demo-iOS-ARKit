//
//  SCNode+Text.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import ARKit

extension SCNNode {
    
    static func text(
        withString string: String,
        color: UIColor,
        opacity: CGFloat = 1,
        fontSize: Float = 0.035,
        heightAbove: Float = 0.0001,
        shouldLookAtNode lookAtNode: SCNNode? = nil,
        addAboveExistingNode existingNode: SCNNode? = nil) -> SCNNode {
            
            let text = SCNText(string: string, extrusionDepth: 0.1)
            text.font = UIFont.systemFont(ofSize: 0.3)
            text.flatness = 0.01
            text.firstMaterial?.diffuse.contents = color
            let textNode = SCNNode(geometry: text)
            textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
            
            var pivotCorrection = SCNMatrix4Identity
            
            if let lookAtNode = lookAtNode {
                let constraint = SCNLookAtConstraint(target: lookAtNode)
                constraint.isGimbalLockEnabled = true
                textNode.constraints = [constraint]
                pivotCorrection = SCNMatrix4Rotate(pivotCorrection, .pi, 0, 1, 0)
            }
            
            let (min, max) = text.boundingBox
            pivotCorrection = SCNMatrix4Translate(pivotCorrection, (max.x - min.x) / 2, 0, 0)
            textNode.pivot = pivotCorrection
            
            if let existingNode = existingNode {
                
                textNode.position = SCNVector3(0.01, heightAbove, 0)
                existingNode.addChildNode(textNode)
            }
            textNode.opacity = opacity
            textNode.name = string
            return textNode
        }
}
