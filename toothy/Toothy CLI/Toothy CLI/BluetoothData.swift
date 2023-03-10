//
//  BluetoothData.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import CoreBluetooth
import Foundation

enum BluetoothServices {
    static let fitnessMachine = CBUUID(string: "1826")
}

enum BluetoothCharacteristics {
    static let fitnessMachineControlPoint = CBUUID(string: "2AD9")
}
