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
//    var maxFOV:Float = Float(M_PI)

    init(camera:VRCamera) {
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


class TechniqueLoader {
    static func LoadFromJson(path:String) -> SCNTechnique {
        var technique = SCNTechnique()
        let data = NSData(contentsOfFile: path)
        do {
            let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            technique = SCNTechnique(dictionary: dict as! Dictionary)!
            
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
        }
        return technique
    }

}


class VRCamera: SCNNode {
    
    let left : SCNNode = SCNNode()
    let right : SCNNode = SCNNode()
    let barrel_shader = SCNTechnique()
    var interpupilaryDistance:Float = 0 {
        willSet
        {
            left.position = SCNVector3(x: -newValue/2, y: 0, z: 0)
            right.position = SCNVector3(x: newValue/2, y: 0, z: 0)
        }
    }
    
    init(interpupilaryDistance:Float = 6.0) {
        super.init()
        
        left.camera = SCNCamera()
        left.name = "Left"
        self.addChildNode(left);
        
        right.camera = SCNCamera()
        right.name = "Right"
        self.addChildNode(right);
    
        
        { self.interpupilaryDistance = interpupilaryDistance } ()
        
        setupBarrelShader()
 

    }
    
    func setupBarrelShader() {
        
        let path = NSBundle.mainBundle().URLForResource("samples.scnassets/barrelDistortion", withExtension: "plist")
        let dic = NSDictionary(contentsOfURL: path!)
        let technique = SCNTechnique(dictionary: dic as! Dictionary)
        
        left.camera?.technique = technique
        right.camera?.technique = technique
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
