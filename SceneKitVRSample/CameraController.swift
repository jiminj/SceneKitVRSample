//
//  CameraController.swift
//  SceneKitVRSample
//
//  Created by Jimin Jeon on 3/2/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import UIKit
import SceneKit

class CameraController {
    
    var camera : SCNNode
    //    var maxFOV:Float = Float(M_PI)
    
    init(camera:SCNNode) {
        self.camera = camera
    }
    
    func tilt(let tiltInc:vector_float3, speed:Float = 1, inverted:Bool = true) {
        
        let sign:Float = inverted ? 1.0 : -1.0
        let newCameraAng = vector_float3(camera.eulerAngles) + sign * tiltInc * speed
        camera.eulerAngles = SCNVector3( newCameraAng )
        
        //        if(vector_length(newCameraAng) < maxFOV)
        //        {
        //            camera.eulerAngles = SCNVector3( newCameraAng )
        //        }
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