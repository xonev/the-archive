//
//  PeripheralRegistration.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 3/10/23.
//

import Foundation
import CoreBluetooth

struct PeripheralRegistration {
    let identifier: UUID
    let peripheral: CBPeripheral
    let advertisementData: [String: Any]
    let rssi: NSNumber

    init(identifier: UUID, peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        self.identifier = identifier
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.rssi = rssi
    }
}
