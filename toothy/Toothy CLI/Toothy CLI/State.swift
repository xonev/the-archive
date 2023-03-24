//
//  State.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 3/20/23.
//

import Foundation

class State {
    var peripheralRegistry: PeripheralRegistry

    init(peripheralRegistry: PeripheralRegistry) {
        self.peripheralRegistry = peripheralRegistry
    }

    func updatePeripheralRegistry(_ updateFunc: (PeripheralRegistry) -> PeripheralRegistry) {
        peripheralRegistry = updateFunc(peripheralRegistry)
    }
}
