//
//  main.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/5/23.
//

import CoreBluetooth
import OSLog

let logger = Logger(subsystem: "com.stevenoxley.Toothy", category: "main")
let state = State(peripheralRegistry: PeripheralRegistry())
let central = Central(state: state, dispatchQueue: DispatchQueue(label: "CentralManagerQueue"))
logger.debug("Created central")
print("Type quit<enter> to quit")
while let input = readLine() {
    if input == "quit" {
        exit(0)
    }
}
