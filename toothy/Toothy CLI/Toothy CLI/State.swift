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
    var servicesState: ServicesState {
        queue.sync {
            return _servicesState
        }
    }
    private var _peripheralRegistry: PeripheralRegistry
    private var _servicesState: ServicesState
    private let queue = DispatchQueue(label: "SerialStateDispatch")

    init(peripheralRegistry: PeripheralRegistry, servicesState: ServicesState) {
        self._peripheralRegistry = peripheralRegistry
        self._servicesState = servicesState
    }

    func updatePeripheralRegistry(_ updateFunc: (PeripheralRegistry) -> PeripheralRegistry) {
        queue.sync {
            _peripheralRegistry = updateFunc(_peripheralRegistry)
        }
    }

    func updateServicesState(_ updateFunc: (ServicesState) -> ServicesState) {
        queue.sync {
            _servicesState = updateFunc(_servicesState)
        }
    }

}
