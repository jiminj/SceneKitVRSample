//
//  Extensions.swift
//  SceneKitSample
//
//  Created by Jimin Jeon on 2/28/16.
//  Copyright © 2016 Jimin Jeon. All rights reserved.
//

import SceneKit

extension float3 {
    init(_ v:CGPoint) {
        self.init(Float(v.x), Float(v.y), 0)
    }
    init(_ v:SCNVector3){
        self.init(v.x, v.y, v.z)
    }
}