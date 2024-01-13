//
//  ServiceState.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 4/23/23.
//

import Foundation
import CoreBluetooth

struct ServiceState {
    var identifier: CBUUID
    var service: CBService
    var includedServicesRetrieved: Bool
    var characteristicsRetrieved: Bool
    var isDiscoveryCompleted: Bool { includedServicesRetrieved && characteristicsRetrieved }
}
