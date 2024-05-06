//
//  BluetoothServiceObserver.swift
//  Bluetooth
//
//  Created by Alexey Papin on 06.05.2024.
//

import CoreBluetooth

public protocol BluetoothServiceObserver: AnyObject {
	func didUpdate(state: CBManagerState)
	func didDiscover(infos: [BluetoothService.PeripheralInfo])
	func didUpdate(peripheral: CBPeripheral)
}
