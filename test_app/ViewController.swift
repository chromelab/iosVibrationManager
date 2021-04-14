//
//  ViewController.swift
//  MultiVibeUserStudy
//
//  Created by John Pasquesi on 10/31/19.
//  Copyright © 2019 John Pasquesi. All rights reserved.
//

import UIKit

import CoreHaptics

class ViewController: UIViewController {
    
    private lazy var supportsHaptics: Bool = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.supportsHaptics
    }()
    
    // Track the screen dimensions:
    private lazy var windowWidth: CGFloat = {
        return UIScreen.main.bounds.size.width
    }()
    
    private lazy var windowHeight: CGFloat = {
        return UIScreen.main.bounds.size.height
    }()
    
    // Constants
    private let margin: CGFloat = 16
    private let buttonHeight: CGFloat = 50
    
    // Tokens to track whether app is in the foreground or the background:
    private var foregroundToken: NSObjectProtocol?
    private var backgroundToken: NSObjectProtocol?
    
    private lazy var areaSize: CGFloat = {
        let totalWidth = windowWidth/2 - 3 * margin
        let totalHeight = windowHeight/2 - 2 * margin
        return min(totalWidth, totalHeight / 2)
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Ensure the background matches the device appearance.
        self.view.backgroundColor = .systemBackground
        
//        let touchAreaFrame = CGRect(x: margin, y: buttonHeight, width: windowWidth - 3 * margin, height: windowHeight - margin - buttonHeight)
//        
//        let touchArea = UIView(frame: touchAreaFrame)
//        
//        touchArea.backgroundColor = UIColor.gray
//        self.view.addSubview(touchArea)
    
    }
    
    
    
}


