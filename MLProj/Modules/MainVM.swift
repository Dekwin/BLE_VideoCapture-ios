//
//  MainVM.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/8/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation

class MainVM {
    
    private let videoCaptureService: VideoCaptureService
    private let blePeripheral:BLEPeripheralService
    
    init(blePeripheral: BLEPeripheralService, videoCaptureService: VideoCaptureService) {
        self.blePeripheral = blePeripheral
        self.videoCaptureService = videoCaptureService
        configureServices()
        
    }
    
    private func configureServices() {
        do {
            try videoCaptureService.configure(withFilesSource: VideoFilesSource(withFilesSourceURL: FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!))
        } catch {
            
        }
    }
    
    static func configuredVM() -> MainVM {
        return MainVM(blePeripheral: BLEPeripheralService(), videoCaptureService: VideoCaptureService())
    }
}
