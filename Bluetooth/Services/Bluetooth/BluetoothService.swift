//
//  BluetoothService.swift
//  Bluetooth
//
//  Created by Alexey Papin on 06.05.2024.
//

import CoreBluetooth

public final class BluetoothService: NSObject {
	public struct PeripheralInfo {
		var peripheral: CBPeripheral
		var advertisementData: [String: Any]
		var rssi: NSNumber
	}
	
	public var state: CBManagerState = .unknown
	public var discoveredPeripherals: [CBPeripheral] {
		discoveredPeripheralInfos.map { $0.peripheral }
	}
	
	private var observers: [BluetoothServiceObserver] = []
	private var connectPeripheralCompletions: [CBPeripheral: ((Result<Void, Error>) -> Void)] = [:]
	private let centralManager = CBCentralManager()
	private var discoveredPeripheralInfos: [PeripheralInfo] = []
	
	public func add(observer: BluetoothServiceObserver) {
		guard !observers.contains(where: { $0 === observer }) else { return }
		observers.append(observer)
	}
	
	public func start() {
		centralManager.delegate = self
	}
	
	public func delete(observer: BluetoothServiceObserver) {
		guard let index = observers.firstIndex(where: { $0 === observer }) else { return }
		observers.remove(at: index)
	}
	
	public func connect(peripheral: CBPeripheral, completion: ((Result<Void, Error>) -> Void)?) {
		if let completion {
			connectPeripheralCompletions.updateValue(completion, forKey: peripheral)
		}
		centralManager.stopScan()
		centralManager.connect(peripheral)
	}
}

extension BluetoothService: CBCentralManagerDelegate {
	public func centralManagerDidUpdateState(_ central: CBCentralManager) {
		observers.forEach {
			$0.didUpdate(state: central.state)
		}
		state = central.state
		if state == .poweredOn {
			centralManager.scanForPeripherals(withServices: nil)
		}
	}
	
	public func centralManager(
		_ central: CBCentralManager,
		didDiscover peripheral: CBPeripheral,
		advertisementData: [String : Any],
		rssi RSSI: NSNumber
	) {
		peripheral.delegate = self
		let info = PeripheralInfo(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
		if let index = discoveredPeripheralInfos.firstIndex(where:  { $0.peripheral == peripheral }) {
			discoveredPeripheralInfos[index] = info
		} else {
			discoveredPeripheralInfos.append(info)
		}
		observers.forEach {
			$0.didDiscover(infos: discoveredPeripheralInfos)
		}
	}
	
	public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		guard let completion = connectPeripheralCompletions[peripheral] else { return }
		completion(.success(()))
		connectPeripheralCompletions.removeValue(forKey: peripheral)
	}
	
	public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
		guard let completion = connectPeripheralCompletions[peripheral] else { return }
		completion(.failure(error ?? NSError()))
		connectPeripheralCompletions.removeValue(forKey: peripheral)
	}
	
	public func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
		print(event, peripheral)
	}
}

extension BluetoothService: CBPeripheralDelegate {
	private func update(peripheral: CBPeripheral, rssi: NSNumber? = nil) {
		guard let index = discoveredPeripheralInfos.firstIndex(where: { $0.peripheral == peripheral }) else { return }
		discoveredPeripheralInfos[index].peripheral = peripheral
		if let rssi {
			discoveredPeripheralInfos[index].rssi = rssi
		}
		observers.forEach {
			$0.didUpdate(peripheral: peripheral)
		}
	}
	
	public func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
		update(peripheral: peripheral)
	}
	
	public func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: (any Error)?) {
		update(peripheral: peripheral, rssi: RSSI)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: (any Error)?) {
		update(peripheral: peripheral)
	}
	
	public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
		update(peripheral: peripheral)
	}
	
	public func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: (any Error)?) {
		update(peripheral: peripheral)
	}
}
