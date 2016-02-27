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

class ModelInformation {
    var filename:String
    var scale:SCNVector3
    init(filename:String, scale:SCNVector3) {
        self.filename = filename
        self.scale = scale
    }
}

class ViewController: UIViewController {

    @IBOutlet var leftSceneView: SampleView!
    @IBOutlet var rightSceneView: SampleView!
    
    var sampleView: SampleView { return self.view as! SampleView }
    
    let scene = SCNScene()
//    let cameraNode = SCNNode()
    let cameraNode = VRCamera()
    var cameraController:VRCameraController
    
    var boundaryOffset:Float = 20
    var roomBoundaryAbs:Float = 280
    var roomWidth:Float = 600 {
        willSet{
            roomBoundaryAbs = newValue / 2 - boundaryOffset
        }
    }
    var roomHeight:Float = 200
    
    
    required init(coder aDecoder: NSCoder) {
        cameraController = VRCameraController(camera: cameraNode)
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leftSceneView.backgroundColor = UIColor.blackColor()
        rightSceneView.backgroundColor = UIColor.blackColor()
        leftSceneView.showsStatistics = true
        rightSceneView.showsStatistics = true
        leftSceneView.scene = scene
        rightSceneView.scene = scene
        
        
        cameraNode.position = SCNVector3(x: 0, y: 100, z: 0)
        cameraNode.left.camera?.automaticallyAdjustsZRange = true
        cameraNode.right.camera?.automaticallyAdjustsZRange = true
        scene.rootNode.addChildNode(cameraNode)
        
        
        leftSceneView.pointOfView = cameraNode.left
        rightSceneView.pointOfView = cameraNode.right
        
        roomWidth = 600
        roomHeight = 200
        
        //add gesture control
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        view.addGestureRecognizer(panGestureRecognizer)
        
        generateRoom(roomWidth, height: roomHeight, floorTextureName: "samples.scnassets/wood.png", wallTextureName: "samples.scnassets/wall.jpg")
        addLights()
//
//        let Models:[ModelInformation] = [
//            ModelInformation(filename: "samples.scnassets/Writing_Desk.scn", scale: SCNVector3Make(1.0, 1.0, 1.0)),
//            ModelInformation(filename: "samples.scnassets/Wood_Table.dae", scale: SCNVector3Make(100.0, 100.0, 100.0)),
//            ModelInformation(filename: "samples.scnassets/cat.scn", scale: SCNVector3Make(50.0, 50.0, 50.0)),
//            ModelInformation(filename: "samples.scnassets/Wooden_Chair.scn", scale: SCNVector3Make(50.0, 50.0, 50.0)),
//            ModelInformation(filename: "samples.scnassets/Ambulance.scn", scale: SCNVector3Make(0.2, 0.2, 0.2))
//        ]
////
//        addModels(Models, radius:200)

    }
    
    //temporal solution
    var currentGestureNumberOfTouches = 0;

    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        if(gestureRecognizer.state == UIGestureRecognizerState.Began)
        {
//            cameraInitAng = cameraNode.eulerAngles
//            cameraInitPos = cameraNode.position
            cameraController.actionBegin()
            
            currentGestureNumberOfTouches = gestureRecognizer.numberOfTouches()
            return
        }
        if(gestureRecognizer.state == UIGestureRecognizerState.Ended)
        {
            currentGestureNumberOfTouches = 0
            return
        }

//        if(gestureRecognizer.numberOfTouches() > 1) {
        if(currentGestureNumberOfTouches > 1) {
            moveCamera(gestureRecognizer.translationInView(self.view))
            return
        }
        else {
            tiltCamera(gestureRecognizer.translationInView(self.view))
            return
        }
    }
    
    func tiltCamera(point:CGPoint, speed:Float=0.005) {
        cameraController.tilt(vector_float2(Float(point.x), Float(point.y)), inverted: true)
    }
    
    
    func moveCamera(point:CGPoint) {
        cameraController.move(vector_float2(Float(point.x), Float(point.y)), inverted: true)
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
        scene.rootNode.addChildNode(floorNode)

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
        wall.firstMaterial?.doubleSided = false
        wall.firstMaterial?.shininess = 0.0
        
        var wallNode = SCNNode(geometry: wall)
        wallNode.position = SCNVector3Make(0, halfHeight, -halfWidth)
        wallNode.physicsBody = SCNPhysicsBody.staticBody()
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

        let ceilNode = SCNNode(geometry: SCNPlane(width: CGFloat(width), height: CGFloat(width)))
        ceilNode.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 22, alpha: 1)
        ceilNode.position = SCNVector3Make(0, height, 0)
        ceilNode.rotation = SCNVector4Make(1, 0, 0, Float(M_PI_2))

        scene.rootNode.addChildNode(ceilNode)
    }
    

    
    func addModels(modelList: [ModelInformation], radius:Float ) {
//
        let spotlight = SCNLight()
        spotlight.type = SCNLightTypeSpot
        spotlight.color = UIColor(white: 1.0, alpha: 1.0)
        spotlight.castsShadow = false;
//        spotlight.shadowColor = UIColor(white: 0.1, alpha: 0.5)
        spotlight.zNear = 30
        spotlight.zFar = CGFloat(roomHeight) + 10
        spotlight.shadowRadius = 1.0
        spotlight.spotInnerAngle = 20
        spotlight.spotOuterAngle = 45
        
        let cnt = modelList.count
        let angleStep = 2 * M_PI / Double(cnt)
        var curAngle:Double = 0
        
        for model in modelList {
            
            let curX:Float = Float(sin(curAngle)) * radius
            let curZ:Float = Float(cos(curAngle)) * radius
            
            let node = SCNNode()
            let loadedScene = SCNScene(named: model.filename)
            let modelNode = loadedScene!.rootNode.childNodes[0]
            print(loadedScene!.rootNode)
            modelNode.scale = model.scale

            let spotlightNode = SCNNode()
            spotlightNode.light = spotlight
            spotlightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI_2));
            spotlightNode.position = SCNVector3Make(0, roomHeight, 0)

            print(curX, curZ, curAngle)
            
            node.addChildNode(modelNode)
            node.addChildNode(spotlightNode)
            node.position = SCNVector3Make(curX, 0, -curZ)
            node.rotation = SCNVector4Make(0, 1, 0, -Float(curAngle))

            scene.rootNode.addChildNode(node)
            curAngle += angleStep
        }
                
    }
    
    func addLights() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeSpot
//        lightNode.light?.type = SCNLightTypeOmni
        lightNode.rotation = SCNVector4Make(1, 0, 0, Float(-M_PI_2));
        lightNode.position = SCNVector3Make(0, roomHeight, 0)
        lightNode.light?.color = UIColor(white: 1.0, alpha: 0.6)
        lightNode.light?.castsShadow = false;
//        lightNode.light?.shadowColor = UIColor(white: 0.5, alpha: 0.1)
        lightNode.light?.spotInnerAngle = 120
        lightNode.light?.spotOuterAngle = 180
        lightNode.light?.zNear = 30;
        lightNode.light?.zFar = 800;
        lightNode.light?.attenuationStartDistance = 100
        lightNode.light?.attenuationEndDistance = 800
        lightNode.light?.attenuationFalloffExponent = 1.0

        scene.rootNode.addChildNode(lightNode)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

