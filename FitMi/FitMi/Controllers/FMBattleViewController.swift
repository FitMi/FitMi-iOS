//
//  FMBattleViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 16/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import BubbleTransition

class FMBattleViewController: FMViewController {
	
	@IBOutlet var tableView: UITableView!
	
	let transition = BubbleTransition()
	var segueStartCenter = CGPoint.zero
	
	fileprivate var data:JSON?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.registerCells()
        self.configureTableView()
    }
	
	private func loadFake() {
		let str = "[{\"name\": \"Bohan\", \"id\":\"1843175555914388\", \"level\":10}, {\"name\":\"Jinghan\", \"id\":\"100003031938297\", \"level\":14}]"
		let data = str.data(using: .utf8)
		self.data = JSON(data: data!)
		
		self.tableView.reloadData()
	}
	
	private func registerCells() {
		FMFriendListCell.registerCell(tableView: self.tableView, reuseIdentifier: FMFriendListCell.identifier)
	}

	private func configureTableView() {
		self.tableView.estimatedRowHeight = 100
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 88, right: 0)
		self.tableView.backgroundColor = UIColor.secondaryColor
		
		self.tableView.delaysContentTouches = false
		
		for case let x as UIScrollView in self.tableView.subviews {
			x.delaysContentTouches = false
		}
		
		let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
		headerLabel.font = UIFont(name: "Pixeled", size: 20)
		headerLabel.text = "BATTLE!"
		headerLabel.textAlignment = .center
		self.tableView.tableHeaderView = headerLabel
	}
	
	override func willMove(toParentViewController parent: UIViewController?) {
		super.willMove(toParentViewController: parent)
		
		self.loadFake()
	}
	
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
	}
	
	private static var defaultController: FMBattleViewController?
	class func getDefaultController() -> FMBattleViewController {
		if FMBattleViewController.defaultController == nil {
			let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "FMBattleViewController") as! FMBattleViewController
			FMBattleViewController.defaultController = controller
		}
		
		return FMBattleViewController.defaultController!
	}

}

extension FMBattleViewController: UIViewControllerTransitioningDelegate {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let controller = segue.destination
		transition.duration = 0.2
		controller.transitioningDelegate = self
		controller.modalPresentationStyle = .custom
		
		if segue.identifier == "combatSegue" {
			let controller = segue.destination as! FMBattleDetailViewController
			let indexPath = sender as! IndexPath
			let id = "\(self.data![indexPath.row]["id"])"
			controller.opponentID = id
		}
	}
	
	// MARK: UIViewControllerTransitioningDelegate
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .present
		transition.startingPoint = self.segueStartCenter
		transition.bubbleColor = UIColor.primaryColor
		return transition
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .dismiss
		transition.startingPoint = self.segueStartCenter
		transition.bubbleColor = UIColor.primaryColor
		return transition
	}
}


extension FMBattleViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.data == nil ? 0 : self.data!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FMFriendListCell.identifier, for: indexPath) as! FMFriendListCell
		
		let row = indexPath.row
		cell.contentView.backgroundColor = row % 2 == 1 ? UIColor(white: 1, alpha: 0.3) : UIColor.clear
		
		let json = self.data![row]
		let name = json["name"].string
		
		cell.nameLabel.text = name
		cell.avatarImageView.image = UIImage(named: "page0Image0")
		cell.avatarImageView.af_setImage(withURL: URL(string: "http://graph.facebook.com/\(json["id"])/picture?type=large")!)
		cell.levelLabel.text = "lv. \(json["level"])"
		
		return cell
	}
}

extension FMBattleViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.segueStartCenter = self.view.center
		self.performSegue(withIdentifier: "combatSegue", sender: indexPath)
	}
}
