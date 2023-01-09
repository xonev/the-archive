//
//  main.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/5/23.
//

import Foundation
import CoreBluetooth

class Central: NSObject, CBCentralManagerDelegate {
    var central: CBCentralManager! = nil

    init(dispatchQueue: DispatchQueue?) {
        super.init()
        self.central = CBCentralManager(delegate: self, queue: dispatchQueue)
    }

    func scan() {
        self.central.scanForPeripherals(withServices: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case CBManagerState.poweredOn:
            self.scan()
        default:
            print("State is \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            print("Discovered peripheral \(name)")
        }
    }
}

let central = Central(dispatchQueue: DispatchQueue(label: "CentralManagerQueue"))
print("Created central")
print("Type quit<enter> to quit")
while let input = readLine() {
    if input == "quit" {
        exit(0)
    }
}
