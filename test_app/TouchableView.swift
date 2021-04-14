//
//  TouchableView.swift
//  MultiVibeUserStudy
//
//  Created by John Pasquesi on 11/1/19.
//  Copyright © 2019 John Pasquesi. All rights reserved.
//

import UIKit

class TouchableView: UIView {
    
    // Track the screen dimensions:
    private lazy var windowWidth: CGFloat = {
        return UIScreen.main.bounds.size.width
    }()
    
    private lazy var windowHeight: CGFloat = {
        return UIScreen.main.bounds.size.height
    }()
    
    private let margin: CGFloat = 16
    
    private lazy var topMargin: CGFloat = windowHeight / 8
    
    private lazy var areaSize: CGFloat = {
        let totalWidth = windowWidth/2 - 3 * margin
        let totalHeight = windowHeight/2 - 2 * margin
        return min(totalWidth, totalHeight / 2)
    }()
    
    var touchViews = [UITouch:TouchSpotView]()
    private var vibEng01: VibrationManager?
    private var vibEng02: VibrationManager?
    private var vibEng03: VibrationManager?
    private var vibEng04: VibrationManager?
    private var vibEng05: VibrationManager?
    private var vibrationAreaActive: Bool = false
    private var area01Active: Bool = false
    private var area02Active: Bool = false
    private var area03Active: Bool = false
    private var area04Active: Bool = false
    private var area05Active: Bool = false
    private var area01Type: Character = "Z"
    private var area02Type: Character = "Z"
    private var area03Type: Character = "Z"
    private var area04Type: Character = "Z"
    private var area05Type: Character = "Z"
    private var numVibs: Int = 0
    private var patt: [Character] = ["Z", "Z", "Z", "Z", "Z"]
    private var calPatt: [Character] = ["Z", "Z"]
    private var numAreas: Int = 0
    private var trialTime = 0.0
    private var timer = Timer()
    private var isPlaying = false
    private var calTrialsRemaining = 15
    private var trialsRemaining = 10
    
    private var patternSelector = VibrationPatternSelector()
    
    private var startButton: UIButton
    private var endButton: UIButton
    private var resetButton: UIButton
    private var calStartButton: UIButton
    private var calNextButton: UIButton
    private var calEndButton: UIButton
    
    private var trialsRemainingLabel: UILabel
    
    private let buttonHeight: CGFloat = 50
    
    private lazy var x_grid_size: CGFloat = (windowWidth - 3 * margin - areaSize)
    private lazy var y_grid_size: CGFloat = (windowHeight - margin - buttonHeight - areaSize)
    private lazy var ymax: CGFloat = buttonHeight + y_grid_size - margin
    private lazy var ymin: CGFloat = buttonHeight
    
    private var area01y: CGFloat = 0
    private var area02y: CGFloat = 0
    private var area03y: CGFloat = 0
    private var area04y: CGFloat = 0
    private var area05y: CGFloat = 0
    
    private var area01x: CGFloat = 0
    private var area02x: CGFloat = 0
    private var area03x: CGFloat = 0
    private var area04x: CGFloat = 0
    private var area05x: CGFloat = 0
    
    private var calText: String = "Time Elapsed, Vibration 1, Vibration 2\n"
    private var mainText: String = "Time Elapsed, Unique Vibrations, Vibration Areas, Vibration 1, Vibration 2, Vibration 3, Vibration 4, Vibration 5\n"
    
    private var calFile: String = "CalibrationData.csv"
    private var mainFile: String = "MainData.csv"
    
    var fingers = [UITouch?](repeating: nil, count:5)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches{
            let point = touch.location(in: self)
            for (index,finger)  in fingers.enumerated() {
                if finger == nil {
                    fingers[index] = touch
                    //print("finger \(index+1): x=\(point.x) , y=\(point.y)")
                    break
                }
            }
        }
        areaCheck()
        handleVibrations()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            let point = touch.location(in: self)
            for (index,finger) in fingers.enumerated() {
                if let finger = finger, finger == touch {
                    //print("finger \(index+1): x=\(point.x) , y=\(point.y)")
                    break
                }
            }
        }
        areaCheck()
        handleVibrations()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            for (index,finger) in fingers.enumerated() {
                if let finger = finger, finger == touch {
                    fingers[index] = nil
                    break
                }
            }
        }
        areaCheck()
        handleVibrations()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        let touches = touches
        touchesEnded(touches, with: event)
        areaCheck()
        handleVibrations()
    }
 
   override init(frame: CGRect) {
        startButton = UIButton(frame: CGRect(x:300, y:0, width: 100, height: 50))
        endButton = UIButton(frame: CGRect(x:500, y:0, width: 100, height: 50))
        resetButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        calStartButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        calEndButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        calNextButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        trialsRemainingLabel = UILabel(frame: CGRect(x:400, y:0, width: 100, height: 50) )
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        vibEng01 = VibrationManager()
        vibEng02 = VibrationManager()
        vibEng03 = VibrationManager()
        vibEng04 = VibrationManager()
        vibEng05 = VibrationManager()
   }
 
   required init?(coder aDecoder: NSCoder) {
        startButton = UIButton(frame: CGRect(x:300, y:0, width: 100, height: 50))
        endButton = UIButton(frame: CGRect(x:500, y:0, width: 100, height: 50))
        resetButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        calStartButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        calEndButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        calNextButton = UIButton(frame: CGRect(x:400, y:0, width: 100, height: 50))
        trialsRemainingLabel = UILabel(frame: CGRect(x:450, y:0, width: 100, height: 50) )
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = true
        vibEng01 = VibrationManager()
        vibEng02 = VibrationManager()
        vibEng03 = VibrationManager()
        vibEng04 = VibrationManager()
        vibEng05 = VibrationManager()
        startButton.backgroundColor = .green
        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        startButton.isHidden = true
        
        endButton.backgroundColor = .red
        endButton.setTitle("End", for: .normal)
        endButton.addTarget(self, action: #selector(endAction), for: .touchUpInside)
        endButton.isHidden = true
    
        resetButton.backgroundColor = .blue
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        resetButton.isHidden = true
    
        calStartButton.backgroundColor = .green
        calStartButton.setTitle("Start Cal", for: .normal)
        calStartButton.addTarget(self, action: #selector(calStartAction), for: .touchUpInside)
        calStartButton.isHidden = false
    
        calNextButton.backgroundColor = .blue
        calNextButton.setTitle("Next", for: .normal)
        calNextButton.addTarget(self, action: #selector(calNextAction), for: .touchUpInside)
        calNextButton.isHidden = true
    
        calEndButton.backgroundColor = .red
        calEndButton.setTitle("End Cal", for: .normal)
        calEndButton.addTarget(self, action: #selector(calEndAction), for: .touchUpInside)
        calEndButton.isHidden = true
    
        trialsRemainingLabel.backgroundColor = .clear
        trialsRemainingLabel.text = String(format: "%d", trialsRemaining)
        trialsRemainingLabel.isHidden = true
        
        
    
        let touchAreaFrame = CGRect(x: margin, y: buttonHeight, width: windowWidth - 3 * margin, height: windowHeight - margin - buttonHeight)
    
        let touchArea = UIView(frame: touchAreaFrame)
    
        touchArea.backgroundColor = UIColor.gray
        touchArea.isUserInteractionEnabled = false
        self.addSubview(touchArea)
        
        self.addSubview(startButton)
        self.addSubview(endButton)
        self.addSubview(resetButton)
        self.addSubview(calStartButton)
        self.addSubview(calNextButton)
        self.addSubview(calEndButton)
        self.addSubview(trialsRemainingLabel)
    
        
   }
    
    func handleVibrations(){
        
        if area01Active {
            //print("Area 01 active")
            if vibEng01?.engine == nil{
                switch area01Type{
                case "A":
                    vibEng01?.vibrateAtFrequencyForever(frequency: 3.0)
                case "B":
                    vibEng01?.vibrateAtFrequencyForever(frequency: 10.0)
                case "C":
                    vibEng01?.vibrateAtFrequencyForever(frequency: 250.0)
                case "D":
                    vibEng01?.knockForever()
                case "E":
                    vibEng01?.slowPulseForever()
                default:
                    break
                }
            }
        }
        else{
            if vibEng01?.engine != nil{
                vibEng01?.stop()
            }
        }
        
        if area02Active {
            //print("Area 02 active")
            if vibEng02?.engine == nil{
                switch area02Type{
                case "A":
                    vibEng02?.vibrateAtFrequencyForever(frequency: 3.0)
                case "B":
                    vibEng02?.vibrateAtFrequencyForever(frequency: 10.0)
                case "C":
                    vibEng02?.vibrateAtFrequencyForever(frequency: 250.0)
                case "D":
                    vibEng02?.knockForever()
                case "E":
                    vibEng02?.slowPulseForever()
                default:
                    break
                }
            }
        }
        else{
            if vibEng02?.engine != nil{
                vibEng02?.stop()
            }
        }
        
        
        if area03Active {
            //print("Area 03 active")
            if vibEng03?.engine == nil{
                switch area03Type{
                case "A":
                    vibEng03?.vibrateAtFrequencyForever(frequency: 3.0)
                case "B":
                    vibEng03?.vibrateAtFrequencyForever(frequency: 10.0)
                case "C":
                    vibEng03?.vibrateAtFrequencyForever(frequency: 250.0)
                case "D":
                    vibEng03?.knockForever()
                case "E":
                    vibEng03?.slowPulseForever()
                default:
                    break
                }
            }
        }
        else{
            if vibEng03?.engine != nil{
                vibEng03?.stop()
            }
        }
        
        if area04Active {
            //print("Area 04 active")
            if vibEng04?.engine == nil{
                switch area04Type{
                case "A":
                    vibEng04?.vibrateAtFrequencyForever(frequency: 3.0)
                case "B":
                    vibEng04?.vibrateAtFrequencyForever(frequency: 10.0)
                case "C":
                    vibEng04?.vibrateAtFrequencyForever(frequency: 250.0)
                case "D":
                    vibEng04?.knockForever()
                case "E":
                    vibEng04?.slowPulseForever()
                default:
                    break
                }
            }
        }
        else{
            if vibEng04?.engine != nil{
                vibEng04?.stop()
            }
        }
        
        if area05Active {
            //print("Area 05 active")
            if vibEng05?.engine == nil{
                switch area05Type{
                case "A":
                    vibEng05?.vibrateAtFrequencyForever(frequency: 3.0)
                case "B":
                    vibEng05?.vibrateAtFrequencyForever(frequency: 10.0)
                case "C":
                    vibEng05?.vibrateAtFrequencyForever(frequency: 250.0)
                case "D":
                    vibEng05?.knockForever()
                case "E":
                    vibEng05?.slowPulseForever()
                default:
                    break
                }
            }
        }
        else{
            if vibEng05?.engine != nil{
                vibEng05?.stop()
            }
        }
    }
    
    func areaCheck(){
        area01Active = false
        area02Active = false
        area03Active = false
        area04Active = false
        area05Active = false
        
        for item in fingers{
            if item?.location(in: self) != nil{
                let x = item!.location(in: self).x
                let y = item!.location(in: self).y
                
                if case area01x ... area01x + areaSize = x,  case area01y ... area01y + areaSize = y {
                    area01Active = true
                }
                
                if case area02x ... area02x + areaSize = x,  case area02y ... area02y + areaSize = y {
                    area02Active = true
                }
                
                if case area03x ... area03x + areaSize = x,  case area03y ... area03y + areaSize = y {
                    area03Active = true
                }
                
                if case area04x ... area04x + areaSize = x,  case area04y ... area04y + areaSize = y {
                    area04Active = true
                }
                
                if case area05x ... area05x + areaSize = x,  case area05y ... area05y + areaSize = y {
                    area05Active = true
                }
                
//                print(item?.location(in: self).x, item?.location(in: self).y)
            }
        }
    }
    
    func setupTrial() {
        (numVibs, patt, numAreas) = patternSelector.getPattern()
        // print (numVibs)
        if numVibs == 0{
            print("Done! Please Reset")
            resetButton.isHidden = false
            trialsRemainingLabel.isHidden = true
            endButton.isHidden = true
            startButton.isHidden = true
        }
        while patt.count < 5 {
            patt.append("Z")
        }
        patt.shuffle()
        area01Type = patt[0]
        area02Type = patt[1]
        area03Type = patt[2]
        area04Type = patt[3]
        area05Type = patt[4]
        
        area01y = CGFloat.random(in: ymin ..< ymax)
        area02y = CGFloat.random(in: ymin ..< ymax)
        area03y = CGFloat.random(in: ymin ..< ymax)
        area04y = CGFloat.random(in: ymin ..< ymax)
        area05y = CGFloat.random(in: ymin ..< ymax)
        //print(area01y, area02y, area03y, area04y, area05y)
        
        area01x = margin
        area02x = margin + x_grid_size / 4
        area03x = margin + x_grid_size / 2
        area04x = margin + x_grid_size * 3 / 4
        area05x = margin + x_grid_size
        
        areaSize = {
            let totalWidth = windowWidth/2 - 3 * margin
            let totalHeight = windowHeight/2 - 2 * margin
            return min(totalWidth, totalHeight / 2)
        }()
        
        trialTime = 0.0
        
        if (!isPlaying) {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            isPlaying = true
        }
        
    }
    
    func finishTrial(){
         print(trialTime, numVibs, patt, numAreas)
        let newLine = "\(trialTime),\(numVibs),\(numAreas),\(patt[0]),\(patt[1]),\(patt[2]),\(patt[3]),\(patt[4])\n"
        mainText.append(contentsOf: newLine)
        trialsRemaining -= 1
        trialsRemainingLabel.text = String(format: "%d", trialsRemaining)
        if isPlaying {
            timer.invalidate()
            trialTime = 0.0
            isPlaying = false
        }
    }
    
    func setupCalTrial(){
        calPatt = patternSelector.getCalibrationPattern()
        
        areaSize = {
            return max(x_grid_size/2, y_grid_size)
        }()
        
        area01Type = calPatt[0]
        area02Type = calPatt[1]
        
        area01y = ymin
        area02y = ymin
        
        area01x = margin
        area02x = margin + x_grid_size / 1.5
        
        if (!isPlaying) {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            isPlaying = true
        }
        
    }
    
    func finishCalTrial(){
        print(trialTime, calPatt)
        let newLine = "\(trialTime),\(calPatt[0]),\(calPatt[1])\n"
        calText.append(contentsOf: newLine)
        calTrialsRemaining -= 1
        if isPlaying {
           timer.invalidate()
           trialTime = 0.0
           isPlaying = false
        }
        calNextButton.setTitle(String(format: "Next (%d)", calTrialsRemaining), for: .normal)
    }
    
    @objc func calStartAction(){
        calStartButton.isHidden = true
        calNextButton.isHidden = false
        setupCalTrial()
    }
    
    @objc func calNextAction(){
        finishCalTrial()
        setupCalTrial()
        if calPatt == ["Z", "Z"]{
            calNextButton.isHidden = true
            calEndButton.isHidden = false
        }
    }
    
    
    @objc func calEndAction(){
        startButton.isHidden = false
        calEndButton.isHidden = true
        print(calText)
    }
    
    @objc func startAction(){
        startButton.isHidden = true
        endButton.isHidden = false
        trialsRemainingLabel.isHidden = false
        setupTrial()
    }
    
    @objc func endAction(){
        finishTrial()
        startButton.isHidden = false
        endButton.isHidden = true
        area01Type = "Z"
        area02Type = "Z"
        area03Type = "Z"
        area04Type = "Z"
        area05Type = "Z"
    }
    
    @objc func resetAction(){
        startButton.isHidden = false
        trialsRemainingLabel.isHidden = false
        trialsRemaining = 10
        trialsRemainingLabel.text = String(format: "%d", trialsRemaining)
        resetButton.isHidden = true
        print(mainText)
        trialTime = 0.0
        mainText = "Time Elapsed, Unique Vibrations, Vibration Areas, Vibration 1, Vibration 2, Vibration 3, Vibration 4, Vibration 5\n"
        patternSelector = VibrationPatternSelector()
    }
    
    @objc func UpdateTimer() {
        trialTime = trialTime + 0.1
    }
}
