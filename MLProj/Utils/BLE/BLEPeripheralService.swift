//
//  BLEPeripheralService.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/9/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLEDelegate: class {
    func bleStateChanged(state: CBManagerState)
    func bleStartRecordingRequest()
    func bleStopRecordingRequest()
    var state: VideoCaptureState { get }
}

extension BLEDelegate {
    
    func handleWrite(requests: [CBATTRequest]) {
        for request in requests {
            if let command = request.value?.first {
                handleWrite(command: command)
            }
        }
    }
    
    private func handleWrite(command: UInt8) {
        switch command {
        case 0 where state == .recording:
            bleStopRecordingRequest()
           
        case 1 where state == .ready:
             bleStartRecordingRequest()
        default:
            print("Unknown command: \(command), state: \(state).")
            break
        }
    }
    
    func handleRead(request: CBATTRequest, withPeripheral peripheral: CBPeripheralManager) {
        switch state {
        case .ready:
            request.value = Data(bytes: [0x0])
        case .recording:
            request.value = Data(bytes: [0x1])
        case .error:
            request.value = Data(bytes: [0x2])
        }
        peripheral.respond(to: request, withResult: .success)
    }
    
}

enum VideoCaptureState {
    case ready
    case recording
    case error
    
    init(isRecording: Bool?, sessionIsRunning: Bool?) {
        switch (isRecording, sessionIsRunning) {
        case (true, true):
            self = .recording
        default:
            self = .ready
        }
    }
}

class BLEPeripheralService: NSObject {
    
    private var peripheralManager: CBPeripheralManager!
    private let dispatchQueue = DispatchQueue(label: "dqPeripheral", attributes: .concurrent)
    var delegate: BLEDelegate?
    
    private let advertName = "LOL"
    private let serviceUUID = CBUUID(string: "0x180D")
    private let videoCharacteristicUUID = CBUUID(string: "0x2A37")
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: dispatchQueue)
    }

    
}


extension BLEPeripheralService: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            peripheral.startAdvertising([CBAdvertisementDataLocalNameKey : advertName])
        default:
            break
        }
        
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        let videoService = CBMutableService(type: serviceUUID, primary: true)

        let videoManagerCharacteristic = CBMutableCharacteristic(type: videoCharacteristicUUID, properties: [CBCharacteristicProperties.read, CBCharacteristicProperties.write], value: nil, permissions: [CBAttributePermissions.writeable, CBAttributePermissions.readable])
        
        videoService.characteristics = [videoManagerCharacteristic]
        
        peripheral.add(videoService)
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("didadd err \(error)")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        delegate?.handleWrite(requests: requests)
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        delegate?.handleRead(request: request, withPeripheral: peripheral)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        
    }
    
}
