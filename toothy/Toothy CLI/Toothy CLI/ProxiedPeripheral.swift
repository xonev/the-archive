//
//  ProxiedPeripheral.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation

class ProxiedPeripheral: NSObject, CBPeripheralDelegate {
    let proxiedPeripheral: CBPeripheral
    let advertisementData: [String: Any]

    init(_ proxiedPeripheral: CBPeripheral, advertisementData: [String: Any]) {
        self.proxiedPeripheral = proxiedPeripheral
        self.advertisementData = advertisementData
        super.init()
        self.proxiedPeripheral.delegate = self
    }

    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        logger.debug("Discovering services")
        proxiedPeripheral.discoverServices(serviceUUIDs)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let servicesDescription = proxiedPeripheral.services?.debugDescription
        logger.debug("Discovered services \(servicesDescription!)")
    }
}

