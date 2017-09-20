//
//  CellVCs.swift
//  Breakout
//
//  Created by Michael Gasparovic on 4/4/17.
//  Copyright © 2017 Michael Gasparovic. All rights reserved.
//

import Foundation
import UIKit

class SliderCell: UITableViewCell {
    
    let settings = Settings()
    
    @IBOutlet weak var sliderControl: UISlider!
    
    @IBAction func changeSpeed(_ sender: UISlider) {
        self.settings.speed = Double(sender.value)
    }
    
    override func layoutSubviews() {
        self.sliderControl.value = Float(self.settings.speed)
    }
}

class StepperCell: UITableViewCell {
    
    let settings = Settings()
    
    @IBOutlet weak var numRows: UILabel!
    
    @IBOutlet weak var stepperControl: UIStepper!
    
    @IBAction func changeNumRows(_ sender: UIStepper) {
        self.settings.numBrickRows = Int(sender.value)
        self.numRows.text = "\(Int(sender.value))"
    }
    
    override func layoutSubviews() {
        var value = self.settings.numBrickRows
        if value > 9 { value = 9 }
        else if value < 0 { value = 0 }
        self.stepperControl.value = Double(value)
        self.numRows.text = "\(value)"
        self.stepperControl.maximumValue = 9.0
        self.stepperControl.minimumValue = 1.0
    }
}

class SegmentedCell: UITableViewCell {
    
    let settings = Settings()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func changeNumberBalls(_ sender: UISegmentedControl) {
        self.settings.numBalls = sender.selectedSegmentIndex + 1
    }
    
    override func layoutSubviews() {
        self.segmentedControl.selectedSegmentIndex = self.settings.numBalls - 1
    }
    
}
