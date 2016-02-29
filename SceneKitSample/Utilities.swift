//
//  Utilities.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/29/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import SceneKit


class ModelInformation {
    var filename:String
    let type:String?
    var scale:SCNVector3 = SCNVector3(1.0, 1.0, 1.0)
    var rotation:SCNVector4 = SCNVector4()
    init(filename:String, scale:SCNVector3 = SCNVector3(1.0, 1.0, 1.0), rotation:SCNVector4 = SCNVector4()) {
        self.filename = filename
        self.type = NSURL(fileURLWithPath: filename).pathExtension
        self.scale = scale
        self.rotation = rotation
    }
}


class ModelLoader {
    static func load(model:ModelInformation?) -> SCNNode? {
        if let modelType = model?.type {
            switch modelType {
                case "scn":
                    return loadScn(model)
                default:
                    return nil
            }
        }
        return nil
    }
    
    static func loadScn(model:ModelInformation?) -> SCNNode? {
        if let filename = model?.filename {
            let modelScene = SCNScene(named: filename)
            return self.modulation(model, node: modelScene?.rootNode.childNodes[0] )
        }
        return nil
    }
    
    static private func modulation(modelInfo:ModelInformation?, node:SCNNode?) -> SCNNode?
    {
        if(modelInfo != nil)
        {
            node?.scale = modelInfo!.scale
            node?.rotation = modelInfo!.rotation
        }
        return node
    }
}



class TechniqueLoader {
    static func load(url:NSURL?) -> SCNTechnique? {
        if let techniqueType = url?.pathExtension {
            switch(techniqueType) {
                case "plist":
                    return loadFromPlist(url)
                case "json":
                    return loadFromJson(url)
                default:
                    return nil
            }
        }
        return nil
    }
    
    static func loadFromJson(url:NSURL?) -> SCNTechnique? {
        if let techniqueUrl = url {
            let data:NSData? = NSData(contentsOfURL: techniqueUrl)
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                return SCNTechnique(dictionary: dict as! Dictionary)
                
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    static func loadFromPlist(let url:NSURL?) -> SCNTechnique? {
        if let techniqueUrl = url {
            let dic:NSDictionary? = NSDictionary(contentsOfURL: techniqueUrl)
            return SCNTechnique(dictionary: dic as! Dictionary)
        }
        return nil
    }
}
