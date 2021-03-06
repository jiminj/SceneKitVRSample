//
//  SceneGenerator.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/29/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import SceneKit

class SampleSceneComposer {
    
    let scene:SCNScene
    
    var roomWidth:Float = 10.0
    var roomHeight:Float = 3.0
    let spotlightTemplate:SCNLight = SCNLight()
    
    init(scene:SCNScene, width:Float, height:Float)
    {
        self.scene = scene
        setRoomSize(width, height: height)
        loadFloor("samples.scnassets/wood.png")
        loadWalls("samples.scnassets/wall.jpg")
        loadLights()
    }
    
    func setRoomSize(width:Float, height:Float)
    {
        roomWidth = width
        roomHeight = height
    }
    
    func loadObject(model:ModelInformation, position:SCNVector3, rotation:SCNVector4, spotlight:Bool) {
        
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
    
    
    private func loadFloor(textureName:String) {
        
        //Floor
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial?.diffuse.contents = textureName
        floor.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(100.0, 100.0, 100.0)
        floor.firstMaterial?.locksAmbientWithDiffuse = true
        floor.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Nearest;
        floor.firstMaterial?.doubleSided = false
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        scene.rootNode.addChildNode(floorNode)
        
    }
    
    private func loadWalls(textureName:String) {
        
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
    
    private func loadLights() {
        
        spotlightTemplate.type = SCNLightTypeSpot
        spotlightTemplate.color = UIColor(white: 1.0, alpha: 1.0)
        spotlightTemplate.castsShadow = true;
        spotlightTemplate.shadowColor = UIColor(white: 0.1, alpha: 0.5)
        spotlightTemplate.shadowRadius = 1.0
        spotlightTemplate.zNear = 1.0
        spotlightTemplate.zFar = CGFloat(roomHeight) + 1.0
        spotlightTemplate.spotInnerAngle = 30
        spotlightTemplate.spotOuterAngle = 50
        
        let roomLight = SCNLight()
        roomLight.type = SCNLightTypeSpot
        roomLight.color = UIColor(white: 1.0, alpha: 0.3)
        
        roomLight.castsShadow = true;
        roomLight.shadowColor = UIColor(white: 0.1, alpha: 0.5)
        roomLight.zNear = 1.0;
        roomLight.zFar = CGFloat(roomWidth);
        roomLight.spotInnerAngle = 90
        roomLight.spotOuterAngle = 150

        
        let roomLightNode = SCNNode()
        roomLightNode.light = roomLight
        roomLightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI_2));
        roomLightNode.position = SCNVector3Make(0, roomHeight * 1.2, 0)
        
        scene.rootNode.addChildNode(roomLightNode)

        
    }
    
    
}
