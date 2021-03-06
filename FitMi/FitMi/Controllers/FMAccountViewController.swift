//
//  FMAccountViewController.swift
//  FitMi
//
//  Created by Jinghan Wang on 1/10/16.
//  Copyright © 2016 FitMi. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import JWTDecode

class FMAccountViewController: FMViewController {

	private static var defaultController: FMAccountViewController?
    let networkManager = FMNetworkManager.sharedManager
	
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
		self.tableView.backgroundColor = UIColor.secondaryColor
		self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
		self.registerCells()
		
		let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
		headerLabel.font = UIFont(name: "Pixeled", size: 20)
		headerLabel.text = "SETTINGS"
		headerLabel.textAlignment = .center
		headerLabel.backgroundColor = UIColor.secondaryColor
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
    
    // TODO: Example call for combat; remove after clean up
    func createNewCombat() {
        let sprite = FMSpriteStatusManager.sharedManager.sprite!
        // Do the same for the toUser's skill in use
        let skillInUse = sprite.skillsInUse
        var skills: [String] = []
        for skill in skillInUse {
            skills.append(skill.identifier)
        }

        let prefs = UserDefaults.standard
        do {
            let jwt = try decode(jwt: prefs.string(forKey: "jwt")!)
            let userId = jwt.claim(name: "_id").string!
            let name = jwt.claim(name: "name").string!
            
            let data = [
                "combat": [
                    "toUserId": userId,
                    "fromUserStatus": [
                        "displayName": name,
                        "strength": sprite.states.last?.strength as Int!,
                        "stamina": sprite.states.last?.stamina as Int!,
                        "health": sprite.states.last?.health as Int!,
                        "health_limit": sprite.states.last?.health as Int!,
                        "level": sprite.states.last?.level as Int!,
                        "appearance": sprite.appearanceIdentifier,
                        "skills": skills
                    ],
                    "toUserStatus": [
                        "displayName": name,
                        "strength": sprite.states.last?.strength as Int!,
                        "stamina": sprite.states.last?.stamina as Int!,
                        "health": sprite.states.last?.health as Int!,
                        "health_limit": sprite.states.last?.health as Int!,
                        "level": sprite.states.last?.level as Int!,
                        "appearance": sprite.appearanceIdentifier,
                        "skills": skills
                    ],
                    "winner": userId,
                    "moves": [[
                        "attackUser": userId,
                        "skillId": "skill-D4D534EE-297B-42C3-B8CA-77906414B14B",
                        "defenceUser": userId,
                        "damage": 50,
                        "healing": 0,
                        "nextMoveResumeTime": 0
                        ]]
                ]
            ]
            
            
            self.networkManager.createCombat(combat: data) { (error, res) in
                if (error != nil) {
                    // Error
                } else {
                    // TODO: login process finished
                    print(res ?? "Empty Response")
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription) // error decode jwt
            return
        }
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
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 3
		case 1:
			return 3
		default:
			return 1
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
				let cell = tableView.dequeueReusableCell(withIdentifier: FMLabelCell.identifier, for: indexPath) as! FMLabelCell
				cell.selectionStyle = .none
				cell.highlightEnabled = true
				cell.titleLabel.text = "STEPS GOAL"
				var count = FMSpriteStatusManager.sharedManager.sprite?.states.last?.stepGoal
				count = count == nil ? 0 : count
				cell.contentLabel.text = "\(count!)"
				return cell
			case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier: FMLabelCell.identifier, for: indexPath) as! FMLabelCell
				cell.selectionStyle = .none
				cell.highlightEnabled = true
				cell.titleLabel.text = "DISTANCE GOAL"
				var count = FMSpriteStatusManager.sharedManager.sprite?.states.last?.distanceGoal
				count = count == nil ? 0 : count
				cell.contentLabel.text = "\(count!) m"
				return cell
			case 2:
				let cell = tableView.dequeueReusableCell(withIdentifier: FMLabelCell.identifier, for: indexPath) as! FMLabelCell
				cell.selectionStyle = .none
				cell.highlightEnabled = true
				cell.titleLabel.text = "FLIGHTS GOAL"
				var count = FMSpriteStatusManager.sharedManager.sprite?.states.last?.flightsGoal
				count = count == nil ? 0 : count
				cell.contentLabel.text = "\(count!) FLOOR\(count! > 1 ? "S" : "")"
				return cell
			default:
				print("indexPath not supported")
			}
			
		case 2:
			switch indexPath.row {
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: FMMiddleAlignedLabelCell.identifier, for: indexPath) as! FMMiddleAlignedLabelCell
				cell.selectionStyle = .none
				cell.label.font = UIFont(name: "Pixeled", size: 12)
                cell.backgroundColor = UIColor.secondaryColor
                cell.label.textColor = UIColor.white
                cell.cardView.layer.borderWidth = 0
                let prefs = UserDefaults.standard
                if prefs.string(forKey: "jwt") != nil && AccessToken.current != nil {
                    cell.label.text = "FACEBOOK LOGOUT"
                    cell.cardView.backgroundColor = .logOutRed
                } else {
                    cell.label.text = "FACEBOOK LOGIN"
                    cell.cardView.backgroundColor = .facebookBlue
                }
				return cell
			default:
				print("indexPath not supported")
			}
		default:
			print("indexPath not supported")
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return ""
	}
	
}

extension FMAccountViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = FMSectionHeaderView.viewFromNib()
		switch section {
		case 0:
			view.titleLabel.text = "Mi"
		case 1:
			view.titleLabel.text = "GOAL"
		default:
			view.titleLabel.text = "BATTLE"
		}
		return view
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = UIColor.secondaryColor
		return view
	}
	
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
		case 1:
			print("goal")
			let controller = FMGoalSettingViewController.controllerFromStoryboard()
			FMRootViewController.defaultController.present(controller, animated: true, completion: nil)
			
        case 2:
            switch indexPath.row {
            case 0:
                let prefs = UserDefaults.standard
                if prefs.string(forKey: "jwt") != nil && AccessToken.current != nil {
                    // TODO: add some confirmation dialog
                    prefs.set(nil, forKey: "jwt")
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
                } else {
                    FMRootViewController.defaultController.addChildViewController(self)
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    loginManager.logIn([ .publicProfile, .userFriends ], viewController: self) { loginResult in
                        self.removeFromParentViewController()
                        switch loginResult {
                        case .failed(let error):
                            // TODO
                            print(error)
                        case .cancelled:
                            // Should do nothing
                            print("User cancelled login.")
                        case .success(_, _, let accessToken):
                            self.networkManager.authenticateWithToken(token: accessToken.authenticationToken, completion: {
                                error, token in
                                if let apiToken = token {
                                    prefs.set(apiToken, forKey: "jwt")
                                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
                                    // Update Sprite id
                                    do {
                                        let jwt = try decode(jwt: apiToken)
                                        
                                        if let userId = jwt.claim(name: "_id").string {
											FMDatabaseManager.sharedManager.realmUpdate {
												FMSpriteStatusManager.sharedManager.sprite?.identifier = userId
											}
                                        }
										
										if let facebookID = jwt.claim(name: "fbId").string {
											FMDatabaseManager.sharedManager.realmUpdate {
												FMSpriteStatusManager.sharedManager.sprite?.userFacebookID = facebookID
											}
										}
										
										if let name = jwt.claim(name: "name").string {
											FMDatabaseManager.sharedManager.realmUpdate {
												FMSpriteStatusManager.sharedManager.sprite?.userFacebookName = name
											}
										}
                                        
                                        FMGameCenterManager.sharedManager.completeAchievement(achievementId: AchievementId.FACEBOOK_LOGIN.rawValue)
										
                                        FMSpriteStatusManager.sharedManager.pushSpriteStatusToRemote(completion: { (error, success) in
                                            if (error != nil) {
                                                print(error!)
                                            } else {
                                                prefs.set(Date(), forKey: "lastSyncTime")
                                            }
                                        })
                                    } catch let error as NSError {
                                        print(error.localizedDescription) // error decode jwt
                                    }
                                }
                            })
                        }
                    }
                }
            default:
                print("indexPath not supported")
            }
		default:
			print("indexPath not supported")
		}

	}
}
