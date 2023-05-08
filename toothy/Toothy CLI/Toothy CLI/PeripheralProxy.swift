//
//  Peripheral.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation
import EventDrivenSwift

class PeripheralProxyDelegate: NSObject, CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        default:
            logger.debug("State is \(String(describing: peripheral.state))")
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        logger.debug("Peripheral manager is restoring state")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
            logger.debug("Peripheral manager couldn't add a service")
        }
        logger.debug("Peripheral manager didAdd a service")
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        logger.debug("Peripheral manager did start advertising")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        logger.debug("A remote central didSubscribeTo characteristic \(String(describing: characteristic))")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        logger.debug("A remote central didUnsubscribeFrom characteristic \(String(describing: characteristic))")
    }

    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        logger.debug("Local peripheral is ready toUpdateSubscribers")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        logger.debug("Local peripheral didReceiveRead for \(String(describing: request))")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        logger.debug("Local peripheral didReceiveWrite for \(String(describing: requests))")
    }
}

class PeripheralProxy {
    var peripheral: CBPeripheralManager!
    let proxiedPeripheral: ProxiedPeripheral
    var peripheralProxyDelegate: PeripheralProxyDelegate!
    var peripheralConnectedListener: EventListenerHandling!
    var peripheralServicesDiscoveredListener: EventListenerHandling!

    init(proxiedPeripheral: ProxiedPeripheral, dispatchQueue: DispatchQueue) {
        self.proxiedPeripheral = proxiedPeripheral
        self.peripheralProxyDelegate = PeripheralProxyDelegate()
        self.peripheral = CBPeripheralManager(delegate: peripheralProxyDelegate, queue: dispatchQueue)
        peripheralConnectedListener = PeripheralConnected.addListener(
            self,
            onProxiedPeripheralConnected,
            executeOn: .listenerThread,
            interestedIn: .custom,
            customFilter: proxiedPeripheralEventFilter
        )
        peripheralServicesDiscoveredListener = PeripheralServicesDiscovered.addListener(
            self,
            onPeripheralServicesDiscovered,
            executeOn: .listenerThread,
            interestedIn: .custom,
            customFilter: proxiedPeripheralEventFilter
        )
    }

    func onProxiedPeripheralConnected(_ event: PeripheralConnected, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        logger.debug("PeripheralProxy for \(String(describing: self.proxiedPeripheral)): startAdvertising")
        // peripheral.startAdvertising(proxiedPeripheral.advertisementData)
    }


    func proxiedPeripheralEventFilter(_ event: PeripheralEvent, _ priority: EventPriority, _ dispatchTime: DispatchTime) -> Bool {
        if event.peripheralIdentifier == proxiedPeripheral.identifier {
            return true
        }
        return false
    }
}
