//
//  BluetoothDevice.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/17/24.
//

import Foundation
import CoreBluetooth

struct BluetoothDevice: Identifiable, Hashable {
    
    let periph: CBPeripheral
    let id: String
    let advertisementData: [String: AnyHashable]
    
    init(periph: CBPeripheral, id: String, advertisementData: [String: Any]) {
        self.periph = periph
        self.id = id
        
        var adData: [String: AnyHashable] = [:]
        
        for (key, value) in advertisementData {
            if let anyHash = value as? AnyHashable {
                adData[key] = anyHash
            }
        }
        
        self.advertisementData = adData
    }
}
