//
//  BluetoothService.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/16/24.
//

import Foundation
import CoreBluetooth

protocol BluetoothServiceDelegate {
    func didDiscoverPeripheral(periph: CBPeripheral, advertisementData: [String: Any])
    func didConnectPeripheral(periph: CBPeripheral)
    func didDisconnectPeripheral(periph: CBPeripheral)
    func didReceiveError(error: BluetoothError)
}

class BluetoothService: NSObject {
    
    let manager = CBCentralManager()
    var delegate: BluetoothServiceDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startScanning(delegate: BluetoothServiceDelegate) {
        debugPrint("Starting Scan")
        self.delegate = delegate
        manager.scanForPeripherals(withServices: nil)
    }
    
    func stopScanning() {
        debugPrint("Stopping Scan")
        manager.stopScan()
    }
    
    func disconnect(device: BluetoothDevice) {
        debugPrint("Attempting to disconnect from: \(device.periph.name ?? "No name")")
        manager.cancelPeripheralConnection(device.periph)
    }
    
    func connect(device: BluetoothDevice) {
        debugPrint("Attempting to connect to: \(device.periph.name ?? "No name")")
        manager.connect(device.periph)
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            debugPrint("Bluetooth status unknown")
            break
        case .resetting:
            debugPrint("Resetting bluetooth")
            break
        case .unsupported:
            debugPrint("Bluetooth not supported for this device")
            delegate?.didReceiveError(error: .notSupported)
            break
        case .unauthorized:
            debugPrint("Bluetooth powered unauthorized")
            delegate?.didReceiveError(error: .unauthorized)
            break
        case .poweredOff:
            debugPrint("Bluetooth powered off")
            delegate?.didReceiveError(error: .off)
            break
        case .poweredOn:
            debugPrint("Bluetooth powered on")
            break
        @unknown default:
            debugPrint("Not known state")
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.didDiscoverPeripheral(periph: peripheral, advertisementData: advertisementData)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint("Failed to connect to: \(peripheral.name ?? "No name")")
        if let error = error {
            delegate?.didReceiveError(error: .failedToConnect)
            debugPrint(error)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        debugPrint("Connected to periph: \(peripheral.name ?? "No name")")
        delegate?.didConnectPeripheral(periph: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        debugPrint("Disconnected from periph: \(peripheral.name ?? "No name")")
        if let error = error {
            delegate?.didReceiveError(error: .deviceDisconnected(error: error))
            debugPrint("Disconnected with error: \(error.localizedDescription)")
        }
        delegate?.didDisconnectPeripheral(periph: peripheral)
    }
}
