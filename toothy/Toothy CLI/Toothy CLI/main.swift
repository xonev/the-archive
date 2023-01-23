//
//  main.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/5/23.
//

import CoreBluetooth
import Foundation
import OSLog

let logger = Logger(subsystem: "com.stevenoxley.Toothy", category: "main")

enum BluetoothServices {
    static let fitnessMachine = CBUUID(string: "1826")
}

enum BluetoothCharacteristics {
    static let fitnessMachineControlPoint = CBUUID(string: "2AD9")
}

func opt<T>(_ opt: Optional<T>, withDefault def: T) -> T {
    return opt != nil ? opt! : def
}

class Central: NSObject, CBCentralManagerDelegate {
    var central: CBCentralManager!
    var fitnessMachine: FitnessMachine?

    init(dispatchQueue: DispatchQueue?) {
        super.init()
        self.central = CBCentralManager(delegate: self, queue: dispatchQueue)
    }

    func scan() {
        self.central.scanForPeripherals(withServices: [BluetoothServices.fitnessMachine])
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
        let name = opt(peripheral.name, withDefault: "")
        logger.debug("Discovered peripheral \(name)")
        logger.debug("Connecting to peripheral \(peripheral.debugDescription)")
        fitnessMachine = FitnessMachine(fitnessPeripheral: peripheral)
        central.connect(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let name = opt(peripheral.name, withDefault: "")
        logger.debug("Connected to peripheral \(name)")
        fitnessMachine?.discoverServices([BluetoothServices.fitnessMachine])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        logger.debug("Failed to connect to peripheral \(peripheral.debugDescription): \(error.debugDescription)")
    }
}

class FitnessMachine: NSObject, CBPeripheralDelegate {
    let fitnessPeripheral: CBPeripheral

    init(fitnessPeripheral: CBPeripheral) {
        self.fitnessPeripheral = fitnessPeripheral
        super.init()
        fitnessPeripheral.delegate = self
    }

    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        logger.debug("Discovering services")
        fitnessPeripheral.discoverServices(serviceUUIDs)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let servicesDescription = fitnessPeripheral.services?.debugDescription
        logger.debug("Discovered services \(servicesDescription!)")
    }
}

let central = Central(dispatchQueue: DispatchQueue(label: "CentralManagerQueue"))
logger.debug("Created central")
print("Type quit<enter> to quit")
while let input = readLine() {
    if input == "quit" {
        exit(0)
    }
}
