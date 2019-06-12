//
//  StepSourceTableViewController.swift
//  Workout
//
//  Created by Marco Boschi on 06/03/2017.
//  Copyright © 2017 Marco Boschi. All rights reserved.
//

import UIKit
import HealthKit

class StepSourceTableViewController: UITableViewController, UITextFieldDelegate {
	
	@IBOutlet weak var customSource: UITextField!
	weak var delegate: AboutViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let row: Int
		switch Preferences.stepSourceFilter {
		case .iPhone:
			row = 0
		case .watch:
			row = 1
		case let .custom(str):
			customSource.text = str
			row = 2
		}
		
		tableView.cellForRow(at: IndexPath(row: row, section: 0))?.accessoryType = .checkmark
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		switch indexPath.row {
		case 0:
			Preferences.stepSourceFilter = .iPhone
		case 1:
			Preferences.stepSourceFilter = .watch
		default:
			customSource.becomeFirstResponder()
		}
		
		func setCheckmark() {
			for i in 0 ..< 3 {
				tableView.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .none
			}
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		
		if indexPath.row != 2 {
			customSource.text = ""
			customSource.resignFirstResponder()
			setCheckmark()
		} else if let txt = customSource.text, txt != "" {
			setCheckmark()
			Preferences.stepSourceFilter = .custom(txt)
		}
		
		delegate.updateStepSource()
	}
	
	@IBAction func customSourceDidChange(_ sender: AnyObject) {
		let str = customSource.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		
		if str != "" {
			for i in 0 ..< 3 {
				tableView.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .none
			}
			tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.accessoryType = .checkmark
			
			Preferences.stepSourceFilter = .custom(str)
			delegate.updateStepSource()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}

}