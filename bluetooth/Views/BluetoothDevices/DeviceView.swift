//
//  DeviceView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/17/24.
//

import Foundation
import SwiftUI

struct DeviceView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @State var isConnected: Bool = false
    let device: BluetoothDevice
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.blue)
            VStack(alignment: .center, spacing: 0) {
                if let name = device.periph.name {
                    Text(name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                }
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Identifier")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.top, 4)
                        
                        Text(device.periph.identifier.uuidString)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.top, 2)
                        
                        if device.advertisementData.keys.count > 0 {
                            Text("Advertisement Data")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal)
                                .padding(.top, 4)
                                .foregroundStyle(.white)
                            ForEach(Array(device.advertisementData.keys), id: \.self) { key in
                                if let adData = device.advertisementData[key] as? String {
                                    Text("\(key) \(adData)")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal)
                                } else if let adData = device.advertisementData[key] as? Int {
                                    Text("\(key) \(adData)")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal)
                                } else if let adData = device.advertisementData[key] as? Data {
                                    Text("\(key) \(adData.base64EncodedString())")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
                let connectedButtonText = !isConnected ? "Connect" : "Disconnect"
                let buttonTextColor = !isConnected ? Color.blue : Color.white
                let buttonColor = !isConnected ? Color.white : Color.red
                
                Button {
                    if isConnected {
                        bluetoothManager.disconnect(device: device)
                    } else {
                        bluetoothManager.connect(device: device)
                    }
                } label: {
                    ZStack {
                        Text(connectedButtonText)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(buttonTextColor)
                    }
                    .background(buttonColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
                }
                .padding(.top, 3)
//                else {
//                    Button {
//                        bluetoothManager.disconnect(device: device)
//                    } label: {
//                        ZStack {
//                            Text("Disconnect")
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 8)
//                                .font(.system(size: 14, weight: .semibold))
//                                .foregroundStyle(.white)
//                        }
//                        .background(.red)
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                        .clipped()
//                    }
//                    .padding(.top, 3)
//                }
                Spacer()
            }
        }
        .onChange(of: bluetoothManager.connectedPeripherals) { connectedPeripherals in
            withAnimation {
                isConnected = bluetoothManager.connectedPeripherals.contains(where: { return $0.id == device.id })
            }
        }
    }
}
