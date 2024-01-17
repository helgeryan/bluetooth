//
//  bluetoothApp.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/16/24.
//

import SwiftUI

@main
struct bluetoothApp: App {
    @StateObject var bluetoothManager: BluetoothManager = BluetoothManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bluetoothManager)
        }
    }
}
