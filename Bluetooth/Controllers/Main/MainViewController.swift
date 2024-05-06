//
//  MainViewController.swift
//  Bluetooth
//
//  Created by Alexey Papin on 06.05.2024.
//

import UIKit
import CoreBluetooth

public final class MainViewController: UITableViewController {
	private let bluetoothService = BluetoothService()
	private var infos: [BluetoothService.PeripheralInfo] = []
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .lightGray
		tableView.register(PeripheralCell.self, forCellReuseIdentifier: PeripheralCell.reuseIdentifier)
		tableView.dataSource = self
		tableView.delegate = self
		bluetoothService.add(observer: self)
		bluetoothService.start()
	}
}

// MARK: - UITableViewDataSource
extension MainViewController {
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		infos.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let info = infos[indexPath.row]
		let model = PeripheralCell.Model(name: info.peripheral.name, state: info.peripheral.state.description, rssi: info.rssi.stringValue)
		let cell = tableView.dequeueReusableCell(withIdentifier: PeripheralCell.reuseIdentifier, for: indexPath)
		(cell as? PeripheralCell)?.configure(model: model)
		return cell
	}
}

// MARK: - UITableViewDelegate
extension MainViewController {
	public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		bluetoothService.connect(peripheral: <#T##CBPeripheral#>, completion: <#T##((Result<Void, any Error>) -> Void)?##((Result<Void, any Error>) -> Void)?##(Result<Void, any Error>) -> Void#>)
	}
}

extension MainViewController: BluetoothServiceObserver {
	public func didDiscover(infos: [BluetoothService.PeripheralInfo]) {
		self.infos = infos
		tableView.reloadData()
	}
	
	public func didUpdate(state: CBManagerState) {
		
	}
}
