//
//  ViewController.swift
//  circle
//
//  Created by Animish Gadve on 2/17/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    var listItems = [NSNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleItems()
        tableView.registerNib((UINib (nibName: "MatItemViewCell", bundle: nil)), forCellReuseIdentifier: "matDescriptorCell")
    }

    func loadSampleItems(){
        listItems += [34,54,76,32];
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "matDescriptorCell";
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MatItemViewCell;
        cell.percentageLabel.text = listItems[indexPath.row].stringValue
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

}

