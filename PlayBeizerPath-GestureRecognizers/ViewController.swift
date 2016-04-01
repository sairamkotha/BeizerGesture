//
//  ViewController.swift
//  TestApp
//
//  Created by Sai Ram Kotha  on 21/03/16.
//
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    initTapGesture()

    
  }
  
  func initTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(_:)))
    tapGesture.numberOfTapsRequired = 2
    view.addGestureRecognizer(tapGesture)
  }
  

  func didTap(tapGest: UITapGestureRecognizer) {
    let tapPoint = tapGest.locationInView(view)
    let shapeView = SRShapeView(origin: tapPoint)
    view.addSubview(shapeView)
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(12.0 * Double(NSEC_PER_SEC)) )
    dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
      UIView.animateWithDuration(0.5, animations: { () -> Void in
        shapeView.frame = CGRect(x: tapPoint.x, y: tapPoint.y, width: 0, height: 0)
      })
      let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)) )
      dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
        shapeView.removeFromSuperview()
      }
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}




