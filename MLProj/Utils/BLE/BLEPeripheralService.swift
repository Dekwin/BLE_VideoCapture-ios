//
//  BLEPeripheralService.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/9/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEPeripheralService: NSObject {
    var peripheralManager: CBPeripheralManager!
    let dispatchQueue = DispatchQueue(label: "dqPeripheral", attributes: .concurrent)
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: dispatchQueue)
    }
    
}


extension BLEPeripheralService: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            peripheral.startAdvertising([CBAdvertisementDataLocalNameKey : "LOL"])
        default:
            break
        }
       
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        let service = CBMutableService(type: CBUUID(string: "0x180D"), primary: true)
        let properties = CBCharacteristicProperties.write
        let value: UInt8 = 0xDE
        let data = Data(bytes: [value])
        let characteristic = CBMutableCharacteristic(type: CBUUID(string: "0x2A37"), properties: properties, value: nil, permissions: .writeable)
        service.characteristics = [characteristic]
    
        peripheral.add(service)
        
        
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("didadd err \(error)")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("write req \(requests.first?.value?.first) ")
        
        
    }
    
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        
    }
    
    
    
    
    
    
}
