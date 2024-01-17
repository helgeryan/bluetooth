//
//  HomeView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @State var isError: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if !bluetoothManager.isScanning {
                    Button {
                        withAnimation {
                            bluetoothManager.startScanning()
                        }
                    } label: {
                        Text("Scan for devices")
                            .foregroundStyle(.blue)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding()
                } else {
                    Button {
                        withAnimation {
                            bluetoothManager.stopScanning()
                        }
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
            
            if isError {
                ErrorView()
            }
        }
        .onChange(of: bluetoothManager.bluetoothError) { (error) in
            withAnimation {
                self.isError = error != nil
            }
        }
    }
}
