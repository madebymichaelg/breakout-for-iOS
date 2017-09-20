//
//  SecondViewController.swift
//  Breakout
//
//  Created by Michael Gasparovic on 3/31/17.
//  Copyright © 2017 Michael Gasparovic. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    
    var settings = Settings()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id: String
        switch indexPath.section {
        case 0:
            id = "Segmented Cell"
        case 1:
            id = "Stepper Cell"
        case 2:
            id = "Slider Cell"
        default:
            id = "Slider Cell"
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Balls"
        case 1:
            return "Bricks"
        case 2:
            return "Speed"
        default:
            return "error"
        }
    }

}
