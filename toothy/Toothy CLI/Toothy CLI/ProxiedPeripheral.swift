//
//  ProxiedPeripheral.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation
import EventDrivenSwift

class ProxiedPeripheral: NSObject, CBPeripheralDelegate {
    let proxiedPeripheral: CBPeripheral
    let advertisementData: [String: Any]
    var peripheralConnectedListener: EventListenerHandling?

    init(_ proxiedPeripheral: CBPeripheral, advertisementData: [String: Any]) {
        self.proxiedPeripheral = proxiedPeripheral
        self.advertisementData = advertisementData
        super.init()
        self.proxiedPeripheral.delegate = self
        peripheralConnectedListener = PeripheralConnected.addListener(self, onConnected, executeOn: .listenerThread)
    }

    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        logger.debug("Discovering services")
        proxiedPeripheral.discoverServices(serviceUUIDs)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let servicesDescription = proxiedPeripheral.services?.debugDescription
        logger.debug("Discovered services \(servicesDescription!)")
    }

    func onConnected(_ event: PeripheralConnected, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        discoverServices(nil)
    }
}

