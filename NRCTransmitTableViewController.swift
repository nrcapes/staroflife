//
//  NRCTransmitTableViewController.swift
//  EMS Timers Professional
//
//  Created by Nelson Capes on 7/20/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

import UIKit


class NRCTransmitTableViewController: UITableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if(indexPath.section == 0){
            cell.textLabel?.text = "Email Data"
        }else if(indexPath.section == 1){
            cell.textLabel?.text = "Send Data to Dropbox"
        }else{
            cell.textLabel?.text = "Get Data from Dropbox"
        }
        return cell
    
    }

}
