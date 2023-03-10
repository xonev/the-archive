//
//  Central.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation
import EventDrivenSwift

struct CentralManagerStateUpdate: Eventable {
    var state: CBManagerState
}

struct ReadyForScan: Eventable {
    var services: [CBUUID]?
}

class Central: NSObject, CBCentralManagerDelegate {
    var central: CBCentralManager!
    var proxiedPeripheral: ProxiedPeripheral?
    var centralManagerStateUpdateListener: EventListenerHandling?
    var readyForScanListener: EventListenerHandling?

    init(dispatchQueue: DispatchQueue?) {
        super.init()
        self.central = CBCentralManager(delegate: self, queue: dispatchQueue)
        centralManagerStateUpdateListener = CentralManagerStateUpdate.addListener(self, onCentralManagerStateUpdate, executeOn: .listenerThread)
        readyForScanListener = ReadyForScan.addListener(self, onReadyForScan, executeOn: .listenerThread)
    }

    func onCentralManagerStateUpdate(_ event: CentralManagerStateUpdate, _ priority: EventPriority, _ dispatchTime: DispatchTime) {
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

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        CentralManagerStateUpdate(state: central.state).queue()
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = opt(peripheral.name, withDefault: "")
        logger.debug("Discovered peripheral \(name)")
        logger.debug("Connecting to peripheral \(peripheral.debugDescription)")
        proxiedPeripheral = ProxiedPeripheral(peripheral, advertisementData: advertisementData)
        central.connect(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let name = opt(peripheral.name, withDefault: "")
        logger.debug("Connected to peripheral \(name)")
        proxiedPeripheral?.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        logger.debug("Failed to connect to peripheral \(peripheral.debugDescription): \(error.debugDescription)")
    }
}
