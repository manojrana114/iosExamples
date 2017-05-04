//
//  CurvedPolyLineRenderer.swift
//  MapKitDemo
//
//  Created by Manoj pratap singh rana on 30/04/17.
//  Copyright © 2017 learning. All rights reserved.
//

import UIKit
import MapKit

class CurvedPolyLineRenderer: MKPolylineRenderer {

    override func createPath() {
       /* var line = self.overlay as!MKPolyline
        var points = line.points()
        let startPoint = points[0]
        let endPoint = points[line.pointCount-1]
        
        //Path
        let cp1 = CGPoint(x:startPoint.x + 20, y: 10)
        let cp2 = CGPoint(x: endPoint.x - 20, y:10)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        self.path = path
        */
    }
}
