//
//  Peripheral.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation

class PeripheralProxy: NSObject, CBPeripheralManagerDelegate {
    var peripheral: CBPeripheralManager!
    let proxiedPeripheral: ProxiedPeripheral

    init(proxiedPeripheral: ProxiedPeripheral, dispatchQueue: DispatchQueue) {
        self.proxiedPeripheral = proxiedPeripheral
        super.init()
        self.peripheral = CBPeripheralManager(delegate: self, queue: dispatchQueue)
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        default:
            logger.debug("State is \(String(describing: peripheral.state))")
        }
    }
}
