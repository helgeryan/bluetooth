//
//  ContentView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/16/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                if !bluetoothManager.isScanning {
                    Button {
                        bluetoothManager.startScanning()
                    } label: {
                        Text("Scan for devices")
                            .foregroundStyle(.blue)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding()
                } else {
                    Button {
                        bluetoothManager.stopScanning()
                    } label: {
                        Text("Stop scanning")
                            .foregroundStyle(.blue)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.black)
                        .padding(.bottom, 5)
                }
                
                Divider()
                    .padding()
                
                ScrollView {
                    ForEach(bluetoothManager.discoveredPeripherals) { device in
                        BLEDeviceRow(device: device)
                            .padding()
                    }
                }
            }
            .background(.white)
        }
        .accentColor(.white)
    }
}
