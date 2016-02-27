//
//  VRCamera.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/27/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import UIKit
import SceneKit
import simd

class VRCameraController {
    
    var camera : VRCamera
    var maxFOV:Float = Float(M_PI_2)

    init(camera:VRCamera) {
        self.camera = camera
    }
    
    func tilt(let tiltInc:vector_float3, speed:Float = 1, inverted:Bool = true) {
        
        let sign:Float = inverted ? 1.0 : -1.0
        let newCameraAng = vector_float3(camera.eulerAngles) + sign * tiltInc * speed
        
        if(vector_length(newCameraAng) < maxFOV)
        {
            camera.eulerAngles = SCNVector3( newCameraAng )
        }
    }
    
    func moveOnXZPlane(let moveInc:vector_float2, speed:Float = 1, inverted:Bool = true) {
        
        let sign:Float = inverted ? -1.0 : 1.0
        
        let cosAngY = cos(camera.eulerAngles.y)
        let sinAngY = sin(camera.eulerAngles.y)
        let rotationMatrix:float2x2 = float2x2(rows: [float2(cosAngY, sinAngY), float2(-sinAngY, cosAngY)] )
        var cameraMovement:vector_float2 = rotationMatrix * moveInc * speed
        cameraMovement *= sign

// TODO: collision detection
        
//        if(abs(newCameraPosX) > roomBoundaryAbs) { newCameraPosX = cameraLastPos.x }
//        if(abs(newCameraPosZ) > roomBoundaryAbs) { newCameraPosZ = cameraLastPos.z }

        camera.position.x = camera.position.x + cameraMovement.x
        camera.position.z = camera.position.z + cameraMovement.y

        
    }
    
}

class VRCamera: SCNNode {
    
    let left : SCNNode = SCNNode()
    let right : SCNNode = SCNNode()
    var interpupilaryDistance:Float = 0 {
        willSet
        {
            left.position = SCNVector3(x: -newValue/2, y: 0, z: 0)
            right.position = SCNVector3(x: newValue/2, y: 0, z: 0)
        }
    }
    
    convenience override init() {
        self.init(interpupilaryDistance: 6.0)

    }
    
    init(interpupilaryDistance:Float)
    {
        super.init()
        
        left.camera = SCNCamera()
        left.name = "Left"
        self.addChildNode(left);
        
        right.camera = SCNCamera()
        right.name = "Right"
        self.addChildNode(right);
    
        
        { self.interpupilaryDistance = interpupilaryDistance } ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
