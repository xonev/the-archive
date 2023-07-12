//
//  Central.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation
import EventDrivenSwift

struct CentralManagerStateUpdated: Eventable {
    let state: CBManagerState
}

struct ReadyForScan: Eventable {
    let services: [CBUUID]?
}

struct PeripheralDiscovered: Eventable {
    let peripheralIdentifier: UUID
}

class CentralDelegate: NSObject, CBCentralManagerDelegate {
    let state: State

    init(state: State) {
        self.state = state
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        CentralManagerStateUpdated(state: central.state).queue()
    }

    private func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral:CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) async {
        if state.peripheralRegistry.existsBy(identifier: peripheral.identifier) {
            logger.debug("Peripheral \(peripheral.debugDescription) has already been discovered")
            return
        }
        logger.debug("Discovered peripheral \(peripheral.debugDescription). Registering...")
        let registration = PeripheralRegistration(
            identifier: peripheral.identifier,
            peripheral: peripheral,
            advertisementData: advertisementData,
            rssi: RSSI
        )
        state.updatePeripheralRegistry({r in r.register(registration: registration)})
        PeripheralDiscovered(peripheralIdentifier: peripheral.identifier).queue()
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let name = opt(peripheral.name, withDefault: "")
        logger.debug("Connected to peripheral \(name)")
        PeripheralConnected(peripheralIdentifier: peripheral.identifier).queue()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        logger.error("Failed to connect to peripheral \(peripheral.debugDescription): \(error.debugDescription)")
    }
}


class Central {
    let state: State
    let central: CBCentralManager
    let centralDelegate: CentralDelegate
    var centralManagerStateUpdateListener: EventListenerHandling!
    var readyForScanListener: EventListenerHandling!
    var peripheralDiscoveredListener: EventListenerHandling!
    var proxiedPeripheral: ProxiedPeripheral?
    var peripheralProxy: PeripheralProxy?

    init(state: State, dispatchQueue: DispatchQueue?) {
        self.state = state
        centralDelegate = CentralDelegate(state: state)
        central = CBCentralManager(delegate: centralDelegate, queue: dispatchQueue)
        centralManagerStateUpdateListener = CentralManagerStateUpdated.addListener(self, onCentralManagerStateUpdate, executeOn: .listenerThread)
        readyForScanListener = ReadyForScan.addListener(self, onReadyForScan, executeOn: .listenerThread)
        peripheralDiscoveredListener = PeripheralDiscovered.addListener(self, onPeripheralDiscovered, executeOn: .listenerThread)
    }

    func onCentralManagerStateUpdate(_ event: CentralManagerStateUpdated, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        switch event.state {
        case .poweredOn:
            ReadyForScan(services: [BluetoothServices.fitnessMachine]).queue()
        default:
            logger.debug("State is \(String(describing: event.state))")
        }
    }

    func onReadyForScan(_ event: ReadyForScan, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        self.central.scanForPeripherals(withServices: event.services)
    }

    func onPeripheralDiscovered(_ event: PeripheralDiscovered, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
        let registration = state.peripheralRegistry.getBy(identifier: event.peripheralIdentifier)
        // It probably doesn't make sense to include the proxiedPeripheral and PeripheralProxy instantiation here. It would be better to break
        // this business logic out into a separate class, and maintain the proxy state, etc. there. In fact, having a central place where related
        // events are handled might be nice.
        proxiedPeripheral = ProxiedPeripheral(registration.peripheral, state: state, advertisementData: registration.advertisementData)
        peripheralProxy = PeripheralProxy(proxiedPeripheral: proxiedPeripheral!, dispatchQueue: DispatchQueue(label: "PeripheralManagerQueue"))
        logger.debug("Connecting to peripheral \(registration.peripheral.debugDescription)")
        central.stopScan()
        central.connect(registration.peripheral)
    }
}
