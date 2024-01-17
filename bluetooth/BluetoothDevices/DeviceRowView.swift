//
//  DeviceRowView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/17/24.
//

import Foundation
import SwiftUI

struct BLEDeviceRow: View {
    let device: BluetoothDevice
    var body: some View {
        NavigationLink(destination: {
            DeviceView(device: device)
        }, label: {
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
                                Text(adData)
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .modifier(BLEConnectedBackground(device: device))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
        })
    }
}

struct BLEConnectedBackground: ViewModifier {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    var device: BluetoothDevice

    func body(content: Content) -> some View {
        if !bluetoothManager.connectedPeripherals.contains(where: { return $0.id == device.id }) {
            content.background(.blue)
        } else {
            content.background(.green)
        }
    }
}
