//
//  SampleScene.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/28/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import SceneKit

class ModelInformation {
    var filename:String
    var scale:SCNVector3
    var rotation:SCNVector4
    init(filename:String, scale:SCNVector3, rotation:SCNVector4) {
        self.filename = filename
        self.scale = scale
        self.rotation = rotation
    }
}

class SampleScene : SCNScene {

    var roomWidth:Float = 600
    var roomHeight:Float = 200
    let spotlightTemplate = SCNLight()
    
    
    init(width:Float = 600, height:Float = 200) {
        
        self.roomWidth = width
        self.roomHeight = height

        super.init()
        
        generateRoom(roomWidth, height: roomHeight,
            floorTextureName: "samples.scnassets/wood.png",
            wallTextureName: "samples.scnassets/wall.jpg")
        addLights()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    func generateRoom(width:Float, height:Float, floorTextureName:String, wallTextureName:String) {
        
        //Floor
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial?.diffuse.contents = floorTextureName
        floor.firstMaterial?.locksAmbientWithDiffuse = true
        floor.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Nearest;
        floor.firstMaterial?.doubleSided = false
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        rootNode.addChildNode(floorNode)
        
        //Walls and Ceil
        let halfWidth:Float = width / 2
        let halfHeight:Float = height / 2
        let wallTextureImage:UIImage = UIImage(named: wallTextureName)!
        let wallTextureHeightScale:Float = height / Float(wallTextureImage.size.height)
        let wallTextureWidthScale:Float = width / Float(wallTextureImage.size.width) / wallTextureHeightScale
        
        let wall = SCNPlane(width: CGFloat(width), height: CGFloat(height))
        wall.firstMaterial?.diffuse.contents = wallTextureImage

        wall.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(wallTextureWidthScale, 1, 1)
        wall.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        wall.firstMaterial?.diffuse.wrapT = SCNWrapMode.Mirror
        wall.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Nearest;
        wall.firstMaterial?.locksAmbientWithDiffuse = true
        wall.firstMaterial?.doubleSided = false
        wall.firstMaterial?.shininess = 0.0
        
        var wallNode = SCNNode(geometry: wall)
        wallNode.position = SCNVector3Make(0, halfHeight, -halfWidth)
        wallNode.physicsBody = SCNPhysicsBody.staticBody()
        wallNode.physicsBody?.restitution = 1.0
        wallNode.castsShadow = false
        
        rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(-halfWidth, halfHeight, 0)
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI_2))
        rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(halfWidth, halfHeight, 0)
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI_2))
        rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(0, halfHeight, halfWidth)
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        rootNode.addChildNode(wallNode)
        
        let ceilNode = SCNNode(geometry: SCNPlane(width: CGFloat(width), height: CGFloat(width)))
        ceilNode.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 22, alpha: 1)
        ceilNode.position = SCNVector3Make(0, height, 0)
        ceilNode.rotation = SCNVector4Make(1, 0, 0, Float(M_PI_2))
        
//        rootNode.addChildNode(ceilNode)
    }
    
    func addLights() {
        
        spotlightTemplate.type = SCNLightTypeSpot
        spotlightTemplate.color = UIColor(white: 1.0, alpha: 1.0)
        spotlightTemplate.castsShadow = true;
        spotlightTemplate.shadowColor = UIColor(white: 0.1, alpha: 0.5)
        spotlightTemplate.shadowRadius = 1.0
        spotlightTemplate.zNear = 30
        spotlightTemplate.zFar = CGFloat(roomHeight) + 10
        spotlightTemplate.spotInnerAngle = 30
        spotlightTemplate.spotOuterAngle = 50

        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeSpot
        ambientLight.color = UIColor(white: 1.0, alpha: 1.0)
        
        ambientLight.castsShadow = true;
//        ambientLight.shadowColor = UIColor(white: 0.1, alpha: 1.0)
        ambientLight.shadowRadius = 1.0
        
        ambientLight.zNear = 30;
        ambientLight.zFar = CGFloat(roomWidth);
        ambientLight.spotInnerAngle = 120
        ambientLight.spotOuterAngle = 180
//        lightNode.light?.attenuationStartDistance = 500
//        lightNode.light?.attenuationEndDistance = 800
//        lightNode.light?.attenuationFalloffExponent = 1.0
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        ambientLightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI_2));
        ambientLightNode.position = SCNVector3Make(0, roomHeight - 10, 0)
        
        rootNode.addChildNode(ambientLightNode)
//
//        let testLight = SCNLight()
//        testLight.type = SCNLightTypeSpot
//        testLight.color = UIColor(white: 1.0, alpha: 1.0)
//        testLight.castsShadow = true;
//        testLight.zNear = 30
//        testLight.zFar = 500
//        testLight.shadowRadius = 1.0
//        testLight.spotInnerAngle = 30
//        testLight.spotOuterAngle = 50
////        
//        let testLightNode = SCNNode()
//        testLightNode.light = testLight
//        testLightNode.position = SCNVector3Make(0, roomHeight/3, 0)
//        rootNode.addChildNode(testLightNode)

    }
    
    func addModel(model:ModelInformation, position:SCNVector3, rotation:SCNVector4, spotlight:Bool) {

        
        let node = SCNNode()
        let modelScene = SCNScene(named: model.filename)
        let modelNode = modelScene!.rootNode.childNodes[0]
        modelNode.scale = model.scale
        modelNode.rotation = model.rotation
        
        node.addChildNode(modelNode)

        if(spotlight)
        {

            let spotlightNode = SCNNode()
            
            spotlightNode.light = spotlightTemplate
            spotlightNode.rotation = SCNVector4Make(1, 0, 0, -Float(M_PI_2));
            spotlightNode.position = SCNVector3Make(0, roomHeight, 0)

            
            node.addChildNode(spotlightNode)
        }
        
        
        node.position = position
        node.rotation = rotation

        
        rootNode.addChildNode(node)
    }
    
}
