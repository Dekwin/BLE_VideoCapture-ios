//
//  MainVM.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/8/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
import CoreBluetooth

class MainVM {
    
    private let videoCaptureService: VideoCaptureService
    private let blePeripheral: BLEPeripheralService
    
    init(blePeripheral: BLEPeripheralService, videoCaptureService: VideoCaptureService) {
        self.blePeripheral = blePeripheral
        self.videoCaptureService = videoCaptureService
        configureServices()
       
    }
    
    private func configureServices() {
        do {
            let source = VideoFilesSource(withFilesSourceURL: AppConstants.Video.folderUrl!)
            try videoCaptureService.configure(withFilesSource: source)
        } catch {
            
        }
        blePeripheral.delegate = self
    }
    
    
    func enableBLE() {
        
    }
    
    func disableBLE() {
        
    }
    
    func startRecording() {
        videoCaptureService.startRecordingToFile { (error, urlToSave) in
            print("recording started to file \(urlToSave) error \(error)")
        }
    }
    
    func stopRecording() {
        videoCaptureService.stopRecordingAndSave()
    }
    
    
    static func configuredVM() -> MainVM {
        return MainVM(blePeripheral: BLEPeripheralService(), videoCaptureService: VideoCaptureService())
    }
}

extension MainVM: BLEDelegate {
    
    func bleStateChanged(state: CBManagerState) {
        
    }
    
    func bleStartRecordingRequest() {
        startRecording()
    }
    
    func bleStopRecordingRequest() {
        stopRecording()
    }
    
    var state: VideoCaptureState {
        return videoCaptureService.state
    }
    
    
}
