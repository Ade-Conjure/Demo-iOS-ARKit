//
//  SCNVector3+Distance.swift
//  ARBusStopDemo
//
//  Created by Ade Adegoke on 27/04/2023.
//

import ARKit

extension SCNVector3 {
    func distance(to vector: SCNVector3) -> CGFloat {
        let dx = self.x - vector.x
        let dy = self.y - vector.y
        let dz = self.z - vector.z
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
}

