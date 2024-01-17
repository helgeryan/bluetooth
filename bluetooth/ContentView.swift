//
//  ContentView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/16/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @State var isError: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
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
                
                if isError {
                    if let error = bluetoothManager.bluetoothError {
                        VStack(spacing: 0) {
                            Spacer()
                            Button {
                                withAnimation {
                                    bluetoothManager.clearError()
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(error.localizedDescription)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(.black)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal)
                                        .padding(.top, 4)
                                    
                                    Text("Tap to close")
                                        .font(.system(size: 9, weight: .regular))
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                        .padding(.bottom, 5)
                                    
                                }
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .clipped()
                                .shadow(radius: 10)
                            }
                        }
                        .padding()
                    }
                }
                
            }.onChange(of: bluetoothManager.bluetoothError) { (error) in
                withAnimation {
                    self.isError = error != nil
                }
            }
        }
        .accentColor(.white)
    }
}
