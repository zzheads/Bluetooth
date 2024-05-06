//
//  CBManagerState.swift
//  Bluetooth
//
//  Created by Alexey Papin on 06.05.2024.
//

import CoreBluetooth

extension CBManagerState: CustomStringConvertible {
	public var description: String {
		switch self {
		case .unknown:
			"unknown"
		case .resetting:
			"resetting"
		case .unsupported:
			"unsupported"
		case .unauthorized:
			"unauthorized"
		case .poweredOff:
			"poweredOff"
		case .poweredOn:
			"poweredOn"
		@unknown default:
			"unknown"
		}
	}
}
