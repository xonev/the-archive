//
//  utils.swift
//  Toothy CLI
//
//  Created by Steven Oxley on 1/24/23.
//

import Foundation

func opt<T>(_ opt: Optional<T>, withDefault def: T) -> T {
    return opt != nil ? opt! : def
}
