//
//  BLEService.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/8/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLECentralService: NSObject {
    let dispatchQueue = DispatchQueue(label: "dqCentral", attributes: .concurrent)
    var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: dispatchQueue, options: [:])
    }

    
}

extension BLECentralService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        case .resetting:
            print("Bluetooth status is RESETTING")
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            centralManager.scanForPeripherals(withServices: [CBUUID(string: "0xEC00")])
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        peripheral.discoverServices([])

        self.peripheral = peripheral
        self.peripheral.delegate = self
        centralManager.stopScan()
        
        // STEP 6: connect to the discovered peripheral of interest
        centralManager.connect(self.peripheral)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        peripheral.discoverServices([CBUUID(string: "0xEC00")])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor")
    }
    
}


extension BLECentralService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices")
        if let foundService = peripheral.services?.first{
            peripheral.discoverCharacteristics([CBUUID(string: "0xEC0E")], for: foundService)
            
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("did disc char")
        if let firstCharacteristic = service.characteristics?.first {
            peripheral.setNotifyValue(true, for: firstCharacteristic)
        }
    }
    
    
}
