//
//  ViewController.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/19/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO

class ViewController: UIViewController {

    var sampleView: SampleView { return self.view as! SampleView }
    let scene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let scene = SCNScene()
        sampleView.scene = scene
        sampleView.backgroundColor = UIColor.whiteColor()
        sampleView.allowsCameraControl = true
        sampleView.autoenablesDefaultLighting = true
        let rootNode = sampleView.scene?.rootNode
        
        
        generateRoom(600, height: 200, floorTextureName: "samples.scnassets/wood.png", wallTextureName: "samples.scnassets/wall.jpg")
        
//        //Walls
//        let wallWidth:Float = 400
//        let wallHeight:Float = 100
//        let halfWallWidth:Float = wallWidth / 2
//        let halfWallHeight:Float = wallHeight / 2
//        
//        let wall = SCNPlane(width: CGFloat(wallWidth), height: CGFloat(wallHeight))
//        wall.firstMaterial?.diffuse.contents = "samples.scnassets/wall.jpg"
//        wall.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(24, 2, 1), SCNMatrix4MakeTranslation(0, 1, 0))
//        wall.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
//        wall.firstMaterial?.diffuse.wrapT = SCNWrapMode.Mirror
//        wall.firstMaterial?.doubleSided = false
//        wall.firstMaterial?.locksAmbientWithDiffuse = false
//        
//        var wallNode = SCNNode(geometry: wall)
//        wallNode.position = SCNVector3Make(0, halfWallHeight, -halfWallWidth);
//        scene.rootNode.addChildNode(wallNode)
//
//        wallNode = wallNode.clone()
//        wallNode.position = SCNVector3Make(-halfWallWidth, halfWallHeight, 0);
//        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI_2));
//        scene.rootNode.addChildNode(wallNode)
//
//        wallNode = wallNode.clone()
//        wallNode.position = SCNVector3Make(halfWallWidth, halfWallHeight, 0);
//        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI_2));
//        scene.rootNode.addChildNode(wallNode)
//        
//        wallNode = wallNode.clone()
//        wallNode.position = SCNVector3Make(0, halfWallHeight, halfWallWidth);
//        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI));
//        scene.rootNode.addChildNode(wallNode)
//        
//        
//        let step:Float = 3.0
//        let initRadius:CGFloat = 1.0
//        let numSpheres:Int = 20
//
//        var x:Float = 0.0
//        var radius:CGFloat = initRadius
//        
//        for i in 0..<numSpheres {
//            var sphereColor = UIColor.greenColor()
//            if i % 2 == 0 {
//                sphereColor = UIColor.redColor()
//            }
//            let node = SCNNode(geometry: SCNSphere(radius: radius))
//            node.geometry?.firstMaterial?.diffuse.contents = sphereColor
//            node.position = SCNVector3(x, 3.0, 0.0)
//            rootNode?.addChildNode(node)
//            x += 2 * Float(radius) - 0.05
//            radius -= 0.05
//        }
//

        let deskScene = SCNScene(named: "samples.scnassets/Writing_Desk.scn")!
        let deskNode = deskScene.rootNode.childNodeWithName("desk", recursively: true)!
        scene.rootNode.addChildNode(deskNode)
        
    }

    func generateRoom(width:Float, height:Float, floorTextureName:String, wallTextureName:String) {
        
        //Floor
        let floor = SCNFloor()
        floor.reflectivity = 0.05
        floor.firstMaterial?.diffuse.contents = floorTextureName
        floor.firstMaterial?.locksAmbientWithDiffuse = true
        floor.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat;
        floor.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Nearest;
        floor.firstMaterial?.doubleSided = false
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody.staticBody()
        scene.rootNode.addChildNode(floorNode)

        //Walls
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
        wall.firstMaterial?.doubleSided = false
        wall.firstMaterial?.locksAmbientWithDiffuse = false
        
        var wallNode = SCNNode(geometry: wall)
        wallNode.position = SCNVector3Make(0, halfHeight, -halfWidth);
        scene.rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(-halfWidth, halfHeight, 0);
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI_2));
        scene.rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(halfWidth, halfHeight, 0);
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(-M_PI_2));
        scene.rootNode.addChildNode(wallNode)
        
        wallNode = wallNode.clone()
        wallNode.position = SCNVector3Make(0, halfHeight, halfWidth);
        wallNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI));
        scene.rootNode.addChildNode(wallNode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

