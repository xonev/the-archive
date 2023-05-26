//
//  PeripheralRegistry.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 3/12/23.
//

import Foundation

struct PeripheralRegistry {
    let registry: [UUID: PeripheralRegistration]

    init() {
        registry = [:]
    }

    init(_ registryState: [UUID: PeripheralRegistration]) {
        registry = registryState
    }

    func register(registration: PeripheralRegistration) -> PeripheralRegistry {
        return PeripheralRegistry(
            registry.merging(
                [registration.identifier: registration],
                uniquingKeysWith: {(registration1, registration2) in registration1}
            )
        )
    }

    func getBy(identifier: UUID) -> PeripheralRegistration {
        registry[identifier]!
    }

    func existsBy(identifier: UUID) -> Bool {
        registry[identifier] != nil
    }
}
