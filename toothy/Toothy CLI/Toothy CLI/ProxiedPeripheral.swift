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
    // A PeripheralEvent allows for filtering of events based on the peripheral's identifier
    var peripheralIdentifier: UUID { get }
}

struct PeripheralConnected: PeripheralEvent {
    let peripheralIdentifier: UUID
}

struct PeripheralServicesDiscovered: PeripheralEvent {
    let peripheralIdentifier: UUID
}

struct PeripheralIncludedServicesDiscovered: PeripheralEvent {
    let peripheralIdentifier: UUID
    let serviceUuid: CBUUID
}

struct PeripheralServiceCharacteristicsDiscovered: PeripheralEvent {
    let peripheralIdentifier: UUID
    let serviceUuid: CBUUID
}

struct PeripheralDiscoveryCompleted: PeripheralEvent {
    let peripheralIdentifier: UUID

}

class ProxiedPeripheralDelegate: NSObject, CBPeripheralDelegate {

    init(_ proxiedPeripheral: ProxiedPeripheral) {
        super.init()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let serviceDescription = peripheral.services?.debugDescription
        if error != nil {
            let errDescription = error.debugDescription
            logger.error("Error discovering characteristics \(errDescription) \(serviceDescription!)")
        } else {
            logger.debug("Discovered characteristics for \(serviceDescription!)")
        }
        PeripheralServicesDiscovered(peripheralIdentifier: peripheral.identifier).queue()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        let serviceDescription = service.debugDescription
        if error != nil {
            let errDescription = error.debugDescription
            logger.error("Error discovering characteristics \(errDescription) \(serviceDescription)")
        } else {
            logger.debug("Discovered characteristics for \(serviceDescription)")
        }
        PeripheralIncludedServicesDiscovered(peripheralIdentifier: peripheral.identifier, serviceUuid: service.uuid).queue()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let serviceDescription = service.debugDescription
        if error != nil {
            let errDescription = error.debugDescription
            logger.error("Error discovering characteristics \(errDescription) \(serviceDescription)")
        } else {
            logger.debug("Discovered characteristics for \(serviceDescription)")
        }
        PeripheralServiceCharacteristicsDiscovered(peripheralIdentifier: peripheral.identifier, serviceUuid: service.uuid).queue()
    }
}

class ProxiedPeripheral {
    let peripheral: CBPeripheral
    let state: State
    let advertisementData: [String: Any]
    var proxiedPeripheralDelegate: ProxiedPeripheralDelegate!
    var peripheralConnectedListener: EventListenerHandling!
    var peripheralServicesDiscoveredListener: EventListenerHandling!
    var peripheralIncludedServicesDiscoveredListener: EventListenerHandling!
    var peripheralServiceCharacteristicsDiscoveredListener: EventListenerHandling!

    var identifier: UUID {
        peripheral.identifier
    }

    var services: [CBService]? {
        peripheral.services
    }

    init(_ peripheral: CBPeripheral, state: State, advertisementData: [String: Any]) {
        self.peripheral = peripheral
        self.state = state
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
        peripheralServicesDiscoveredListener = PeripheralServicesDiscovered.addListener(
            self,
            onServicesDiscovered,
            executeOn: .listenerThread,
            interestedIn: .custom,
            customFilter: peripheralEventFilter
        )
        peripheralIncludedServicesDiscoveredListener = PeripheralIncludedServicesDiscovered.addListener(
            self,
            onIncludedServicesDiscovered,
            executeOn: .listenerThread,
            interestedIn: .custom,
            customFilter: peripheralEventFilter
        )
        peripheralServiceCharacteristicsDiscoveredListener = PeripheralServiceCharacteristicsDiscovered.addListener(
            self,
            onCharacteristicsDiscovered,
            executeOn: .listenerThread,
            interestedIn: .custom,
            customFilter: peripheralEventFilter
        )
    }

    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        logger.debug("Discovering services")
        peripheral.discoverServices(serviceUUIDs)
    }

    func discoverAllIncludedServices(_ serviceUUIDs: [CBUUID]?) {
        for (_, serviceState) in state.servicesState.serviceStates.filter({item in !item.value.includedServicesRetrieved}) {
            peripheral.discoverIncludedServices(serviceUUIDs, for: serviceState.service)
        }
    }

    func discoverAllCharacteristics(_ characteristicUUIDs: [CBUUID]?) {
        for (_, serviceState) in state.servicesState.serviceStates.filter({item in !item.value.characteristicsRetrieved}) {
            peripheral.discoverCharacteristics(characteristicUUIDs, for: serviceState.service)
        }
    }

    func onConnected(_ event: PeripheralConnected, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        discoverServices(nil)
    }

    func onServicesDiscovered(_ event: PeripheralServicesDiscovered, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        discoverAllIncludedServices(nil)
        discoverAllCharacteristics(nil)
    }

    func onIncludedServicesDiscovered(_ event: PeripheralIncludedServicesDiscovered, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        state.updateServicesState({
            s in
            var serviceState = s.getBy(identifier: event.serviceUuid)
            serviceState.includedServicesRetrieved = true
            return s.update(identifier: event.serviceUuid, serviceState: serviceState)
        })

        if state.servicesState.isDiscoveryCompleted() {
            PeripheralDiscoveryCompleted(peripheralIdentifier: event.peripheralIdentifier).queue()
        }
    }

    func onCharacteristicsDiscovered(_ event: PeripheralServiceCharacteristicsDiscovered, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        state.updateServicesState({
            s in
            var serviceState = s.getBy(identifier: event.serviceUuid)
            serviceState.characteristicsRetrieved = true
            return s.update(identifier: event.serviceUuid, serviceState: serviceState)
        })

        if state.servicesState.isDiscoveryCompleted() {
            PeripheralDiscoveryCompleted(peripheralIdentifier: event.peripheralIdentifier).queue()
        }
    }

    func peripheralEventFilter(_ event: PeripheralEvent, _ priority: EventPriority, _ dispatchTime: DispatchTime) -> Bool {
        if event.peripheralIdentifier == self.peripheral.identifier {
            return true
        }
        return false
    }
}

