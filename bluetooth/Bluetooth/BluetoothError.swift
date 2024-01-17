//
//  BluetoothError.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/17/24.
//

import Foundation

enum BluetoothError: LocalizedError, Equatable {
    static func == (lhs: BluetoothError, rhs: BluetoothError) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
    
    case failedToConnect
    case deviceDisconnected(error: Error)
    case unauthorized
    case off
    case notSupported
    
    public var errorDescription: String? {
        switch self {
        case .failedToConnect:
            return "Failed to connect"
        case .deviceDisconnected(let error):
            return "Device disconnected with error: \(error.localizedDescription)"
        case .unauthorized:
            return "Bluetooth is unauthorized"
        case .off:
            return "Bluetooth is off"
        case .notSupported:
            return "Bluetooth is not supported"
        }
    }
}
