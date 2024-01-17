//
//  ErrorView.swift
//  bluetooth
//
//  Created by Ryan Helgeson on 1/17/24.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    var body: some View {
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
}
