//
//  FMAccountViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit

class FMAccountViewController: FMViewController {

	private static var defaultController: FMAccountViewController?
	
	@IBOutlet var tableView: UITableView!
	
	override func loadView() {
		super.loadView()
		
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if FMAccountViewController.defaultController == nil {
			FMAccountViewController.defaultController = self
		}
		
		self.configureTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tableView.reloadData()
	}
	
	private func configureTableView() {
		self.tableView.estimatedRowHeight = 100
		self.tableView.rowHeight = UITableViewAutomaticDimension
		
		self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		self.registerCells()
		
		let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
		headerLabel.font = UIFont(name: "Pixeled", size: 20)
		headerLabel.text = "ACCOUNT"
		headerLabel.textAlignment = .center
		self.tableView.tableHeaderView = headerLabel
	}
	
	fileprivate func registerCells() {
		FMLabelCell.registerCell(tableView: self.tableView, reuseIdentifier: FMLabelCell.identifier)
		FMMiddleAlignedLabelCell.registerCell(tableView: self.tableView, reuseIdentifier: FMMiddleAlignedLabelCell.identifier)
	}
	
	var dateFormatter: DateFormatter!
	fileprivate func formattedDate(optionalDate: Date?) -> String {
		if dateFormatter == nil {
			dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, YYYY"
		}
		if let date = optionalDate {
			return dateFormatter.string(from: date)
		} else {
			return ""
		}
	}
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		self.tableView.reloadData()
	}
	
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
	}
	
	class func getDefaultController() -> FMAccountViewController {
		if FMAccountViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMAccountViewController") as! FMAccountViewController
			FMAccountViewController.defaultController = controller
		}
		
		return FMAccountViewController.defaultController!
	}

}

extension FMAccountViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 3
		case 1:
			return 1
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: FMLabelCell.identifier, for: indexPath) as! FMLabelCell
				cell.selectionStyle = .none
				cell.highlightEnabled = true
				cell.titleLabel.text = "Mi NAME"
				cell.contentLabel.text = FMSpriteStatusManager.sharedManager.sprite?.name.uppercased()
				return cell
			case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier: FMLabelCell.identifier, for: indexPath) as! FMLabelCell
				cell.selectionStyle = .none
				cell.highlightEnabled = false
				cell.titleLabel.text = "Mi BIRTHDAY"
				cell.contentLabel.text = self.formattedDate(optionalDate: FMSpriteStatusManager.sharedManager.sprite?.birthday).uppercased()
				return cell
			case 2:
				let cell = tableView.dequeueReusableCell(withIdentifier: FMLabelCell.identifier, for: indexPath) as! FMLabelCell
				cell.selectionStyle = .none
				cell.highlightEnabled = false
				cell.titleLabel.text = "Mi AGE"
				var count = FMSpriteStatusManager.sharedManager.sprite?.states.count
				count = count == nil ? 0 : count
				cell.contentLabel.text = "\(count!) DAY\(count! > 1 ? "S" : "")"
				return cell
			default:
				print("indexPath not supported")
			}
		case 1:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: FMMiddleAlignedLabelCell.identifier, for: indexPath) as! FMMiddleAlignedLabelCell
				cell.selectionStyle = .none
				cell.label.font = UIFont(name: "Pixeled", size: 12)
				cell.label.text = "FACEBOOK LOGIN"
				return cell
			default:
				print("indexPath not supported")
			}
		default:
			print("indexPath not supported")
		}
		
		return UITableViewCell()
	}
}

extension FMAccountViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				let controller = UIAlertController(title: "Update Mi Name", message: nil, preferredStyle: .alert)
				controller.addTextField(configurationHandler: {
					textField in
					textField.text = FMSpriteStatusManager.sharedManager.sprite?.name
				})
				controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {
					_ in
					DispatchQueue.main.async {
						FMDatabaseManager.sharedManager.realmUpdate {
							FMSpriteStatusManager.sharedManager.sprite?.name = (controller.textFields?.first!.text)!
							self.tableView.reloadData()
						}
					}
				}))
				
				self.present(controller, animated: true, completion: nil)
					
			default:
				print("indexPath not supported")
			}
		default:
			print("indexPath not supported")
		}

	}
}
