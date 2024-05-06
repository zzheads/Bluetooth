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
	private var infos: [BluetoothService.PeripheralInfo] = [] {
		didSet {
			models = infos.map { .init(name: $0.peripheral.name, state: $0.peripheral.state.description, rssi: $0.rssi.description) }
			tableView.reloadData()
		}
	}
	private var models: [PeripheralCell.Model] = []
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		tableView.backgroundColor = .white
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
		models.count
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let model = models[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: PeripheralCell.reuseIdentifier, for: indexPath)
		(cell as? PeripheralCell)?.configure(model: model)
		return cell
	}
}

// MARK: - UITableViewDelegate
extension MainViewController {
	public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let info = infos[indexPath.row]
		models[indexPath.row].state = CBPeripheralState.connecting.description
		tableView.reloadRows(at: [indexPath], with: .automatic)
		bluetoothService.connect(peripheral: info.peripheral) { [weak self] result in
			switch result {
			case .success:
				self?.models[indexPath.row].state = CBPeripheralState.connected.description
			case .failure:
				self?.models[indexPath.row].state = CBPeripheralState.disconnected.description
			}
			self?.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
}

extension MainViewController: BluetoothServiceObserver {
	public func didUpdate(peripheral: CBPeripheral) {
		guard let index = infos.firstIndex(where: { $0.peripheral == peripheral }) else { return }
		infos[index].peripheral = peripheral
	}
	
	public func didDiscover(infos: [BluetoothService.PeripheralInfo]) {
		self.infos = infos
	}
	
	public func didUpdate(state: CBManagerState) {
		
	}
}
