//
//  ContentView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/16/24.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationDestination(for: BluetoothDevice.self, destination: { device in
                    DeviceView(device: device)
                })
        }
        .accentColor(.white)
    }
}
