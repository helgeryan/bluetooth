//
//  DeviceRowView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/17/24.
//

import Foundation
import SwiftUI

struct BLEDeviceRow: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @State var isConnected: Bool = false
    let device: BluetoothDevice
    var body: some View {
        let buttonTextColor = isConnected ? Color.green : Color.blue
        NavigationLink(value: device, label: {
            HStack {
                VStack(alignment: .leading) {
                    if let name = device.periph.name {
                        HStack {
                            Spacer()
                            Text(name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                    Text("Identifier")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(device.periph.identifier.uuidString)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 2)
                    
                    if device.advertisementData.keys.count > 0 {
                        Text("Advertisement Data")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        ForEach(Array(device.advertisementData.keys), id: \.self) { key in
                            if let adData = device.advertisementData[key] as? String {
                                Text("\(key) \(adData)")
                                    .font(.system(size: 9, weight: .regular))
                                    .foregroundStyle(.white)
                            } else if let adData = device.advertisementData[key] as? Int {
                                Text("\(key) \(adData)")
                                    .font(.system(size: 9, weight: .regular))
                                    .foregroundStyle(.white)
                            } else if let adData = device.advertisementData[key] as? Data {
                                Text("\(key) \(adData.base64EncodedString())")
                                    .multilineTextAlignment(.leading)
                                        .font(.system(size: 9, weight: .regular))
                                        .foregroundStyle(.white)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(buttonTextColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
            .onChange(of: bluetoothManager.connectedPeripherals) { connectedPeripherals in
                withAnimation {
                    isConnected = bluetoothManager.connectedPeripherals.contains(where: { return $0.id == device.id })
                }
            }
        })
    }
}
