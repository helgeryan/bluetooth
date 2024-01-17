//
//  BluetoothManager.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/16/24.
//

import Foundation
import CoreBluetooth

typealias AdvertisementData = [String: Any]

struct BluetoothDevice: Identifiable {
    
    let periph: CBPeripheral
    let id: String
    let advertisementData: [String: Any]
    
    init(periph: CBPeripheral, id: String, advertisementData: [String: Any]) {
        self.periph = periph
        self.id = id
        self.advertisementData = advertisementData
    }
}

class BluetoothManager: ObservableObject {
    
    var service: BluetoothService = BluetoothService()
    @Published var discoveredPeripherals: [BluetoothDevice] = []
    @Published var connectedPeripherals: [BluetoothDevice] = []
    @Published var isScanning: Bool = false

    func startScanning() {
        isScanning = true
        service.startScanning(delegate: self)
    }
    
    func stopScanning() {
        isScanning = false
        service.stopScanning()
    }
    
    func disconnect(device: BluetoothDevice) {
        service.disconnect(device: device)
    }
    
    func connect(device: BluetoothDevice) {
        service.connect(device: device)
    }
}

extension BluetoothManager: BluetoothServiceDelegate {
    func didConnectPeripheral(periph: CBPeripheral) {
        if let device = discoveredPeripherals.first(where: { return $0.id == periph.identifier.uuidString }) {
            connectedPeripherals.append(device)
        }
    }
    
    func didDisconnectPeripheral(periph: CBPeripheral) {
        connectedPeripherals.removeAll(where: { $0.id == periph.identifier.uuidString })
    }
    
    func didDiscoverPeripheral(periph: CBPeripheral, advertisementData: [String: Any]) {
        let device = BluetoothDevice(periph: periph, id: periph.identifier.uuidString, advertisementData: advertisementData)
        if !discoveredPeripherals.contains(where: { $0.id == periph.identifier.uuidString }) && device.periph.name != nil {
            discoveredPeripherals.append(device)
        }
    }
    
    
}
