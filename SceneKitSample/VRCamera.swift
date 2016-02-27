//
//  VRCamera.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/27/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import UIKit
import SceneKit


class VRCameraController {
    
    var camera : VRCamera
    var maxFOV:Float = Float(M_PI_4)
    var cameraInitPos:SCNVector3 = SCNVector3()
    var cameraLastPos:SCNVector3 = SCNVector3()
    var cameraInitAng:SCNVector3 = SCNVector3()
    var cameraLastAng:SCNVector3 = SCNVector3()
    
    init(camera:VRCamera) {
        self.camera = camera
    }
    
    func actionBegin(){
        cameraInitAng = camera.eulerAngles
        cameraInitPos = camera.position
    }
    
    func tilt(let tiltVec:vector_float2, inverted:Bool = false) {
        
        let newCameraAngY = cameraInitAng.y + Float(tiltVec.x) * 0.005
        var newCameraAngX = cameraInitAng.x + Float(tiltVec.y) * 0.005
        if(abs(newCameraAngX) > Float(M_PI_4)) { newCameraAngX = cameraLastAng.x }

        camera.eulerAngles.x = newCameraAngX
        camera.eulerAngles.y = newCameraAngY

        cameraLastAng = camera.eulerAngles
        
//        
//        let invertedTiltVec = vector2(tiltVec.y, tiltVec.x)
//        let lastCamerAng = vector2(cam.eulerAngles.x, cam.eulerAngles.y)
//        let newCameraAng = lastCamerAng + (inverted ? invertedTiltVec : tiltVec)
//        print(tiltVec, newCameraAng, inverted)
//        
//        if(vector_length(newCameraAng) <= maxFOV)
//        {
//            cam.eulerAngles.x = newCameraAng.x
//            cam.eulerAngles.y = newCameraAng.y
//        }
    }
    
    func move(let moveVec:vector_float2, inverted:Bool = false) {
        


        let cosAngY = cos(camera.eulerAngles.y)
        let sinAngY = sin(camera.eulerAngles.y)
        var newCameraPosX = cameraInitPos.x - moveVec.x * cosAngY - moveVec.y * sinAngY
        var newCameraPosZ = cameraInitPos.z + moveVec.x * sinAngY - moveVec.y * cosAngY

//        if(abs(newCameraPosX) > roomBoundaryAbs) { newCameraPosX = cameraLastPos.x }
//        if(abs(newCameraPosZ) > roomBoundaryAbs) { newCameraPosZ = cameraLastPos.z }

        camera.position.x = newCameraPosX
        camera.position.z = newCameraPosZ
        
        cameraLastPos = camera.position
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
    
    override init() {
        interpupilaryDistance = 0
        
        super.init()
        left.camera = SCNCamera()
        left.name = "Left"
        self.addChildNode(left);
        
        right.camera = SCNCamera()
        right.name = "Right"
        self.addChildNode(right);
        
        { self.interpupilaryDistance = 20.0 }()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
