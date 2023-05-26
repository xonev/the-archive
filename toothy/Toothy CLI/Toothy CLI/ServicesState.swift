//
//  ServiceRegistry.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 4/23/23.
//

import Foundation
import CoreBluetooth

struct ServicesState {
    let serviceStates: [CBUUID: ServiceState]

    init() {
        serviceStates = [:]
    }

    init(_ serviceStates: [CBUUID: ServiceState]) {
        self.serviceStates = serviceStates
    }

    func getBy(identifier: CBUUID) -> ServiceState {
        return serviceStates[identifier]!
    }

    func update(identifier: CBUUID, serviceState: ServiceState) -> ServicesState {
        return ServicesState(
            serviceStates.merging(
                [identifier: serviceState],
                uniquingKeysWith: {(state1, state2) in state1}
            )
        )
    }
}
