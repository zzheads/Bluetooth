//
//  PeripheralCell.swift
//  Bluetooth
//
//  Created by Alexey Papin on 05.05.2024.
//

import UIKit
import SnapKit

public final class PeripheralCell: UITableViewCell {
	static var reuseIdentifier = String(describing: PeripheralCell.self)
	
	private let nameLabel: UILabel = .init()
	private let stateLabel: UILabel = .init()
	private let rssiLabel: UILabel = .init()

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		addSubviews()
		makeConstraints()
		nameLabel.font = .preferredFont(forTextStyle: .caption1)
		stateLabel.font = .preferredFont(forTextStyle: .caption2)
		rssiLabel.font = .preferredFont(forTextStyle: .caption2)
	}
	
	private func addSubviews() {
		[nameLabel, stateLabel, rssiLabel].forEach {
			contentView.addSubview($0)
		}
	}
	
	private func makeConstraints() {
		nameLabel.snp.makeConstraints {
			$0.left.top.bottom.equalToSuperview()
			$0.width.equalToSuperview().dividedBy(2)
		}
		
		stateLabel.snp.makeConstraints {
			$0.top.bottom.equalToSuperview()
			$0.left.equalTo(nameLabel.snp.right)
			$0.width.equalToSuperview().dividedBy(4)
		}
		
		rssiLabel.snp.makeConstraints {
			$0.right.top.bottom.equalToSuperview()
			$0.left.equalTo(stateLabel.snp.right)
			$0.width.equalToSuperview().dividedBy(4)
		}
	}
}

extension PeripheralCell {
	struct Model {
		let name: String?
		let state: String
		let rssi: String
	}
	
	func configure(model: Model) {
		nameLabel.text = model.name
		stateLabel.text = model.state
		rssiLabel.text = model.rssi
	}
}
