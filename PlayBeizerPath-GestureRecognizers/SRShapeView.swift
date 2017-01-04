//
//  ShapeView.swift
//  TestApp
//
//  Created by Sai Ram Kotha on 21/03/16.
//
//

import UIKit

class SRShapeView: UIView {
  
  let size: CGFloat = 150.0
  let lineWidth: CGFloat = 2.0
  var fillColor: UIColor!
  var path: UIBezierPath!
  
  init(origin: CGPoint) {
    super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    self.center = origin
    self.backgroundColor = UIColor.clear
    self.layer.cornerRadius = 0 //size/2
    self.fillColor = randomColor()
    initPanGesture()
  }
  
  func randomColor() -> UIColor {
    let hue: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
  }
  
  func initPanGesture() {
    let panGest = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    self.addGestureRecognizer(panGest)
    let pinchGest = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
    self.addGestureRecognizer(pinchGest)
    let rotationGest = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
    self.addGestureRecognizer(rotationGest)
  }
  
  func didRotate(_ rotGest: UIRotationGestureRecognizer) {
    self.superview?.bringSubview(toFront: self)
    let rotation = rotGest.rotation
    self.transform = self.transform.rotated(by: rotation)
    rotGest.rotation = 0.0
  }
  
  func didPinch(_ pinchGest: UIPinchGestureRecognizer) {
    self.superview?.bringSubview(toFront: self)
    let scale = pinchGest.scale
    self.transform = self.transform.scaledBy(x: scale, y: scale)
    pinchGest.scale = 1.0
  }
  
  func didPan(_ panGest: UIPanGestureRecognizer) {
    self.superview?.bringSubview(toFront: self)
    var translation = panGest.translation(in: self)
    translation = translation.applying(self.transform)
    self.center.x += translation.x
    self.center.y += translation.y
    panGest.setTranslation(CGPoint.zero, in: self)
  }
  
  func randomPath() -> UIBezierPath {
    let insetRect = self.bounds.insetBy(dx: lineWidth, dy: lineWidth)
    let shapeType = arc4random() % 5
    if shapeType == 0 {
      return UIBezierPath(roundedRect: insetRect, cornerRadius: 10.0)
    }
    if shapeType == 1 {
      return UIBezierPath(ovalIn: insetRect)
    }
    if (shapeType == 2) {
      return trianglePathInRect(insetRect)
    } else if shapeType == 3 {
      return regularPolygonInRect(insetRect)
    }
    return starPathInRect(insetRect)
  }
  
  func regularPolygonInRect(_ rect:CGRect) -> UIBezierPath {
    let degree = arc4random() % 10 + 3
    let path = UIBezierPath()
    let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
    var angle:CGFloat = -CGFloat(M_PI / 2.0)
    let angleIncrement = CGFloat(M_PI * 2.0 / Double(degree))
    let radius = rect.width / 2.0
    path.move(to: pointFrom(angle, radius: radius, offset: center))
    for _ in 1...degree - 1 {
      angle += angleIncrement
      path.addLine(to: pointFrom(angle, radius: radius, offset: center))
    }
    path.close()
    return path
  }
  
  func starPathInRect(_ rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    let starExtrusion:CGFloat = 30.0
    let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
    let pointsOnStar = 5 + arc4random() % 10
    var angle:CGFloat = -CGFloat(M_PI / 2.0)
    let angleIncrement = CGFloat(M_PI * 2.0 / Double(pointsOnStar))
    let radius = rect.width / 2.0
    var firstPoint = true
    for _ in 1...pointsOnStar {
      let point = pointFrom(angle, radius: radius, offset: center)
      let nextPoint = pointFrom(angle + angleIncrement, radius: radius, offset: center)
      let midPoint = pointFrom(angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
      if firstPoint {
        firstPoint = false
        path.move(to: point)
      }
      path.addLine(to: midPoint)
      path.addLine(to: nextPoint)
      angle += angleIncrement
    }
    path.close()
    return path
  }
  
  func pointFrom(_ angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
    return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
  }
  
  func trianglePathInRect(_ rect:CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
    path.addLine(to: CGPoint(x: rect.width,y: rect.height))
    path.addLine(to: CGPoint(x: rect.origin.x,y: rect.height))
    path.close()
    return path
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let path = randomPath()
    self.fillColor.setFill()
    path.fill()
    
    var name = "hatch"
    if arc4random() % 2  == 0 {
      name = "cross-hatch"
    }
    let color = UIColor(patternImage: UIImage(named: name)!)
    color.setFill()
    if arc4random() % 2 == 0 {
      path.fill()
    }
    UIColor.black.setStroke()
    path.lineWidth = self.lineWidth
    path.stroke()
    
  }
  
}
