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

    @IBOutlet var leftSceneView: SCNView!
    @IBOutlet var rightSceneView: SCNView!
    
    let scene = SCNScene()
    let sceneManager:SceneManager
    let cameraNode = VRCamera()
    var cameraController:CameraController
    
    var boundaryOffset:Float = 20
    var roomBoundaryAbs:Float = 280
    var roomWidth:Float = 600 {
        willSet{
            roomBoundaryAbs = newValue / 2 - boundaryOffset
        }
    }
    var roomHeight:Float = 200
    
    required init(coder aDecoder: NSCoder) {
        
        sceneManager = SceneManager(scene: scene)
        cameraController = CameraController(camera: cameraNode)
        super.init(coder: aDecoder)!
    
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        sceneManager.generateRoom(1000, height: 200)
        
        leftSceneView.backgroundColor = UIColor.blackColor()
        rightSceneView.backgroundColor = UIColor.blackColor()
        leftSceneView.showsStatistics = true
        rightSceneView.showsStatistics = true
        
        
        let Models:[ModelInformation] = [
            ModelInformation(filename: "samples.scnassets/Writing_Desk.scn"),
            
            ModelInformation(filename: "samples.scnassets/Wood_Table.scn",
                            scale: SCNVector3Make(100.0, 100.0, 100.0),
                            rotation: SCNVector4(1, 0, 0, -Float(M_PI_2))),
            
            ModelInformation(filename: "samples.scnassets/cat.scn",
                            scale: SCNVector3Make(70.0, 70.0, 70.0)),
            
            ModelInformation(filename: "samples.scnassets/Wooden_Chair.scn",
                            scale: SCNVector3Make(50.0, 50.0, 50.0)),
            
            ModelInformation(filename: "samples.scnassets/Ambulance.scn",
                            scale: SCNVector3Make(0.2, 0.2, 0.2),
                            rotation: SCNVector4(0,1,0, Float(M_PI)))
        ]

        
        arrangeModelsOnScene(Models, radius:300)
        
        leftSceneView.scene = scene
        rightSceneView.scene = scene
        
        //Setup Camera
        cameraNode.position = SCNVector3(x: 0, y: 150, z: 0)
        cameraNode.left.camera?.automaticallyAdjustsZRange = true
        cameraNode.right.camera?.automaticallyAdjustsZRange = true
        scene.rootNode.addChildNode(cameraNode)
        
        leftSceneView.pointOfView = cameraNode.left
        rightSceneView.pointOfView = cameraNode.right
        
        
        //Add Gesture Control
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    
    func arrangeModelsOnScene(modelList: [ModelInformation], radius:Float ) {
        
        let cnt = modelList.count
        let angleStep = 2 * M_PI / Double(cnt)
        var curAngle:Double = 0
        
        for model in modelList {
            
            let curX:Float = Float(sin(curAngle)) * radius
            let curZ:Float = Float(cos(curAngle)) * radius
            
            sceneManager.addModel( model,
                        position: SCNVector3Make(curX, 0, -curZ),
                        rotation:SCNVector4Make(0, 1, 0, -Float(curAngle)),
                        spotlight: false )
            
            curAngle += angleStep
        }
    }
    

    
    var panAccumulation:vector_float3 = vector_float3(0,0,0)
    let tiltSpeed:Float = 0.005
    let moveSpeed:Float = 1.0
    
    //temporal solution
    var currentGestureNumberOfTouches = 0
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        if(gestureRecognizer.state == UIGestureRecognizerState.Began)
        {
            panAccumulation = vector_float3(0, 0, 0)
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
    
    
    func moveCamera(point:CGPoint) {
        let curAccumulation = vector_float3(Float(point.x), Float(point.y), 0)
        let diff = curAccumulation - panAccumulation
        
        cameraController.moveOnXZPlane(vector_float2(diff.x, diff.y), speed:moveSpeed, inverted: true)
        panAccumulation = curAccumulation
    }
    
    func tiltCamera(point:CGPoint) {
        let curAccumulation = vector_float3(Float(point.y), Float(point.x), 0)
        cameraController.tilt((curAccumulation - panAccumulation), speed:tiltSpeed, inverted: true)
        panAccumulation = curAccumulation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

