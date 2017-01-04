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

  func didTap(_ tapGest: UITapGestureRecognizer) {
    let tapPoint = tapGest.location(in: view)
    let shapeView = SRShapeView(origin: tapPoint)
    view.addSubview(shapeView)
    
    let delayTime = DispatchTime.now() + Double(Int64(12.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
      UIView.animate(withDuration: 0.5, animations: { () -> Void in
        shapeView.frame = CGRect(x: tapPoint.x, y: tapPoint.y, width: 0, height: 0)
      })
      let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
        shapeView.removeFromSuperview()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}




