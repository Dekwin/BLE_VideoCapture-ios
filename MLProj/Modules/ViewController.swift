//
//  ViewController.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/3/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBAction func bleSwitcherSwitched(_ sender: UISwitch) {
        if sender.isOn {
            vm.startRecording()
        } else {
            vm.stopRecording()
        }
    }
    
    let vm = MainVM.configuredVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


