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
    func bleDidRecieve(command: BLERequestCommand)
    var videoCaptureState: VideoCaptureState { get }
}

extension BLEDelegate {
    
    func handleWrite(requests: [CBATTRequest]) {
        for request in requests {
            if let data = request.value {
                handleWrite(data: data)
            }
        }
    }
    
    private func handleWrite(data: Data) {
        bleDidRecieve(command: BLERequestCommand(commandRepresentation: data))
    }
    
    func handleRead(request: CBATTRequest, withPeripheral peripheral: CBPeripheralManager) {
        request.value = videoCaptureState.dataRepresentation
        peripheral.respond(to: request, withResult: .success)
    }
}

fileprivate extension VideoCaptureState {
    
    var dataRepresentation: Data {
        switch self {
        case .ready:
            return Data(bytes: [0x0])
        case .recording:
            return Data(bytes: [0x1])
        case .error:
            return Data(bytes: [0x2])
        }
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
    weak var delegate: BLEDelegate?
    
    private let advertName = "LOL"
    private let serviceUUID = CBUUID(string: "0x180D")
    private let videoCharacteristicUUID = CBUUID(string: "0x2A37")
    
    var state: CBManagerState {
        return peripheralManager.state
    }
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: dispatchQueue)
    }
    
    func startAdvertising() {
        if !peripheralManager.isAdvertising && peripheralManager.state == .poweredOn {
            peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : advertName])
        }
    }
    
    func stopAdvertising() {
        if peripheralManager.isAdvertising {
            peripheralManager.stopAdvertising()
        }
    }
    
}

extension BLEPeripheralService: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        delegate?.bleStateChanged(state: peripheral.state)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        let videoService = CBMutableService(type: serviceUUID, primary: true)
        
        let videoManagerCharacteristic = CBMutableCharacteristic(type: videoCharacteristicUUID, properties: [CBCharacteristicProperties.read, CBCharacteristicProperties.write], value: nil, permissions: [CBAttributePermissions.writeable, CBAttributePermissions.readable])
        
        videoService.characteristics = [videoManagerCharacteristic]
        
        peripheral.add(videoService)
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
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
