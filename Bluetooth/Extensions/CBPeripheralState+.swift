//
//  CBPeripheralState+.swift
//  Bluetooth
//
//  Created by Alexey Papin on 06.05.2024.
//

import CoreBluetooth

extension CBPeripheralState: CustomStringConvertible {
	public var description: String {
		switch self {
		case .disconnected:
			"disconnected"
		case .connecting:
			"connecting"
		case .connected:
			"connected"
		case .disconnecting:
			"disconnecting"
		@unknown default:
			"unknown"
		}
	}
}
