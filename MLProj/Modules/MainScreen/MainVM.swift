//
//  MainVM.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/8/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLEConfiguratorView: class {
    var bleIsEnabled: Bool { get set }
    func recordingDidStart(withError error: Error?)
    func recordingDidStop()
    func bleState(isPoweredOn: Bool)
    func didRecieve(requestAction: BLERequestAction)
}

class MainVM {
    
    private let videoCaptureService: VideoCaptureService
    private let blePeripheral: BLEPeripheralService
    weak var delegate: BLEConfiguratorView? {
        didSet {
            delegate?.bleState(isPoweredOn: blePeripheral.state == .poweredOn)
        }
    }
    
    var bleActionsLog: [BLERequestAction] = []
    
    init(delegate: BLEConfiguratorView?, blePeripheral: BLEPeripheralService, videoCaptureService: VideoCaptureService) {
        self.blePeripheral = blePeripheral
        self.videoCaptureService = videoCaptureService
        self.delegate = delegate
        blePeripheral.delegate = self
        configureServices()
    }
    
    private func configureServices() {
        do {
            let source = VideoFilesSource(withFilesSourceURL: AppConstants.Video.folderUrl!)
            try videoCaptureService.configure(withFilesSource: source)
        } catch {
            print("configuration error: \(error)")
        }
        
    }
    
    func enableBLE() {
        blePeripheral.startAdvertising()
    }
    
    func disableBLE() {
        blePeripheral.stopAdvertising()
    }
    
    func startRecording() {
        videoCaptureService.startRecordingToFile { [weak self] (error, urlToSave) in
            self?.delegate?.recordingDidStart(withError: error)
            print("recording started to file \(urlToSave) error \(error)")
        }
    }
    
    func stopRecording() {
        videoCaptureService.stopRecordingAndSave()
        delegate?.recordingDidStop()
    }
    
    
    static func configuredVM(withDelegate delegate: BLEConfiguratorView? = nil) -> MainVM {
        return MainVM(delegate: delegate, blePeripheral: BLEPeripheralService(), videoCaptureService: VideoCaptureService())
    }
}

extension MainVM: BLEDelegate {
    
    func bleDidRecieve(command: BLERequestCommand) {
        DispatchQueue.main.async {
            let action = BLERequestAction(command: command, videoCaptureState: self.videoCaptureState)
            self.bleActionsLog.append(action)
            self.delegate?.didRecieve(requestAction: action)
            guard action.isPerformable else {
                return
            }
            switch action.command {
            case .stopRecording:
                self.stopRecording()
            case .startRecording:
                self.startRecording()
                
            default:
                print("Unknown command: \(command), state: \(self.videoCaptureState).")
                break
            }
        }
    }
    
    func bleStateChanged(state: CBManagerState) {
        switch state {
        case .poweredOn:
            if delegate?.bleIsEnabled == true {
                blePeripheral.startAdvertising()
            }
        default:
            break
        }
        delegate?.bleState(isPoweredOn: state == .poweredOn)
    }
    
    var videoCaptureState: VideoCaptureState {
        return videoCaptureService.state
    }
    
}
