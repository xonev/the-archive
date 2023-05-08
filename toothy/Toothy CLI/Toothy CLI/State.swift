//
//  State.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 3/20/23.
//

import Foundation

class State {
    var peripheralRegistry: PeripheralRegistry {
        queue.sync {
            return _peripheralRegistry
        }
    }
    private var _peripheralRegistry: PeripheralRegistry
    private let queue = DispatchQueue(label: "SerialStateDispatch")

    init(peripheralRegistry: PeripheralRegistry) {
        self._peripheralRegistry = peripheralRegistry
    }

    func updatePeripheralRegistry(_ updateFunc: (PeripheralRegistry) -> PeripheralRegistry) {
        queue.sync {
            _peripheralRegistry = updateFunc(_peripheralRegistry)
        }
    }

}
