//
//  TouchSpotView.swift
//  MultiVibeUserStudy
//
//  Created by John Pasquesi on 11/1/19.
//  Copyright © 2019 John Pasquesi. All rights reserved.
//
import UIKit

class TouchSpotView : UIView {
   
    override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = UIColor.lightGray
   }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
   // Update the corner radius when the bounds change.
   override var bounds: CGRect {
      get { return super.bounds }
      set(newBounds) {
         super.bounds = newBounds
         layer.cornerRadius = newBounds.size.width / 2.0
      }
   }
}
