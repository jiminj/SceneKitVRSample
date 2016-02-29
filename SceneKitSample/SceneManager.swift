//
//  SceneGenerator.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/29/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import SceneKit

class SceneManager {
    
    let scene:SCNScene
    var roomWidth:Float = 600
    var roomHeight:Float = 200
    let spotlightTemplate:SCNLight = SCNLight()
    
    init(let scene:SCNScene)
    {
        self.scene = scene
    }
    
    func generateRoom(width:Float, height:Float) {
        
        setRoomSize(width, height: height)
        generateFloor("samples.scnassets/wood.png")
        generateWalls("samples.scnassets/wall.jpg")
        addLights()
    }

    
    func setRoomSize(width:Float, height:Float)
    {
        roomWidth = width
        roomHeight = height
    }
    
    
    func generateFloor(textureName:String) {
        
        //Floor
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial?.diffuse.contents = textureName
        floor.firstMaterial?.locksAmbientWithDiffuse = true
        floor.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Nearest;
        floor.firstMaterial?.doubleSided = false
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        scene.rootNode.addChildNode(floorNode)
        
        //Ceil
        let ceilNode = SCNNode(geometry: SCNPlane(width: CGFloat(roomWidth), height: CGFloat(roomWidth)))
        ceilNode.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 22, alpha: 1)
        ceilNode.position = SCNVector3Make(0, roomHeight, 0)
        ceilNode.rotation = SCNVector4Make(1, 0, 0, Float(M_PI_2))
        
        //scene.rootNode.addChildNode(ceilNode)
    }
    
    func generateWalls(textureName:String) {
        
        //Walls
        let halfWidth:Float = roomWidth / 2
        let halfHeight:Float = roomHeight / 2
        
        let wallTextureImage:UIImage = UIImage(named: textureName)!
        let wallTextureHeightScale:Float = roomHeight / Float(wallTextureImage.size.height)
        let wallTextureWidthScale:Float = roomWidth / Float(wallTextureImage.size.width) / wallTextureHeightScale
        
        let wall = SCNPlane(width: CGFloat(roomWidth), height: CGFloat(roomHeight))

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
        
        scene.rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(-halfWidth, halfHeight, 0)
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI_2))
        scene.rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(halfWidth, halfHeight, 0)
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI_2))
        scene.rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(0, halfHeight, halfWidth)
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        scene.rootNode.addChildNode(wallNode)
        
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
        
        let roomLight = SCNLight()
        roomLight.type = SCNLightTypeSpot
        roomLight.color = UIColor(white: 1.0, alpha: 1.0)
//        roomLight.color = UIColor(red: 0.57, green: 0.55, blue: 0.40, alpha: 1.0)
        
        roomLight.castsShadow = true;
        roomLight.shadowColor = UIColor(white: 0.1, alpha: 0.5)
//        roomLight.shadowRadius = 2.0
        
//        
        roomLight.zNear = 10;
        roomLight.zFar = CGFloat(roomWidth * 2.0);
        roomLight.spotInnerAngle = 120
        roomLight.spotOuterAngle = 180

        //        lightNode.light?.attenuationStartDistance = 500
        //        lightNode.light?.attenuationEndDistance = 800
        //        lightNode.light?.attenuationFalloffExponent = 1.0
        
        let roomLightNode = SCNNode()
        roomLightNode.light = roomLight
        roomLightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI_2));
        roomLightNode.position = SCNVector3Make(0, roomHeight - 10, 0)
        
        scene.rootNode.addChildNode(roomLightNode)
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
        if let modelNode = ModelLoader.load(model)
        {
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
            scene.rootNode.addChildNode(node)
        }
    }
    
}
