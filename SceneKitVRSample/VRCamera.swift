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

class VRCamera: SCNNode {
    
    let left : SCNNode = SCNNode()
    let right : SCNNode = SCNNode()
    let barrelDistortionShader:SCNTechnique?
    var interpupilaryDistance:Float = 0 {
        willSet {
            left.position = SCNVector3(x: -newValue/2, y: 0, z: 0)
            right.position = SCNVector3(x: newValue/2, y: 0, z: 0)
        }
    }
    
    var isBarrelDistortionEnabled:Bool = false {
        willSet {
            if(newValue == true) {
                left.camera?.technique = barrelDistortionShader
                right.camera?.technique = barrelDistortionShader
            }
            else {
                left.camera?.technique = nil
                right.camera?.technique = nil
            }
        }
    }
    
    init(interpupilaryDistance:Float = 0.06, isBarrelDistortionEnabled:Bool = true) {

        //pre-load barrel distortion shader
        let path:NSURL? = NSBundle.mainBundle().URLForResource("samples.scnassets/barrelDistortion", withExtension: "plist")
        barrelDistortionShader = TechniqueLoader.load(path)
        
        super.init()
        
        left.camera = SCNCamera()
        left.name = "Left"
        self.addChildNode(left);
        
        right.camera = SCNCamera()
        right.name = "Right"
        self.addChildNode(right);
        
        {
            self.interpupilaryDistance = interpupilaryDistance
            self.isBarrelDistortionEnabled = isBarrelDistortionEnabled
        
        }()


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
