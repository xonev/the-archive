//
//  ProxiedPeripheral.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation
import EventDrivenSwift

protocol PeripheralEvent: Eventable {
    // A PeripheralEvent is a parent struct that allows for filtering of events based on the peripheral's identifier
    var peripheralIdentifier: UUID { get }
}

struct PeripheralConnected: PeripheralEvent {
    let peripheralIdentifier: UUID
}

class ProxiedPeripheralDelegate: NSObject, CBPeripheralDelegate {

    init(_ proxiedPeripheral: ProxiedPeripheral) {
        super.init()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let servicesDescription = peripheral.services?.debugDescription
        logger.debug("Discovered services \(servicesDescription!)")
    }
}

class ProxiedPeripheral {
    let peripheral: CBPeripheral
    let advertisementData: [String: Any]
    var proxiedPeripheralDelegate: ProxiedPeripheralDelegate?
    var peripheralConnectedListener: EventListenerHandling?

    init(_ peripheral: CBPeripheral, advertisementData: [String: Any]) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.proxiedPeripheralDelegate = ProxiedPeripheralDelegate(self)
        self.peripheral.delegate = self.proxiedPeripheralDelegate
        peripheralConnectedListener = PeripheralConnected.addListener(
            self,
            onConnected,
            executeOn: .listenerThread,
            interestedIn: .custom,
            customFilter: peripheralEventFilter
        )
    }

    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        logger.debug("Discovering services")
        peripheral.discoverServices(serviceUUIDs)
    }


    func onConnected(_ event: PeripheralConnected, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        discoverServices(nil)
    }

    func peripheralEventFilter(_ event: PeripheralEvent, _ priority: EventPriority, _ dispatchTime: DispatchTime) -> Bool {
        if event.peripheralIdentifier == self.peripheral.identifier {
            return true
        }
        return false
    }
}

