//
//  ViewController.swift
//  circle
//
//  Created by Animish Gadve on 2/17/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    static let MAX_ITEMS_IN_SECTION = 2
    static let CELL_INSET = CGFloat(5)

    var listItems = Array<Array<MatItem>>()
    let serverCommunicator = ServerCommunication.sharedInstance
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        
        self.collectionView?.backgroundColor = UIColor.darkGrayColor()
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        let navBarImageView = UIImageView(image: UIImage(named: "NavBarIcon"))
        navigationItem.titleView = navBarImageView
        self.collectionView?.registerNib(UINib(nibName: "MatItemViewCell", bundle: nil), forCellWithReuseIdentifier: "matDescriptorCell")
        self.collectionView?.registerNib(UINib(nibName: "MatVisualizerViewCell", bundle: nil), forCellWithReuseIdentifier: "matVisualizerCell")
        
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), forControlEvents: .ValueChanged)
        collectionView?.addSubview(refreshControl)
        
        var listIconImage = UIImage(named: "ListIcon")
        listIconImage = listIconImage?.imageWithRenderingMode(.AlwaysOriginal)
        let listButton = UIBarButtonItem(image: listIconImage, style: .Plain, target: self, action: #selector(HomeViewController.onListButtonPressed(_:)))
        navigationController?.navigationBar.barTintColor = .None
//        let listButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(HomeViewController.onListButtonPressed(_:)))
        navigationItem.rightBarButtonItem = listButton
        
        getScaleDataFromServer()
    }
    
    func getScaleDataFromServer() {
        serverCommunicator.postDataToServer(ServerCommunication.ParametersForOperation.MatFetchData,headers:ServerCommunication.HeadersForOperation.MatFetchData, completion:{
            (responseData:NSData) -> Void in
            do {
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(responseData, options:.MutableContainers)
                self.listItems.removeAll()
                
                var sectionArray = Array<MatItem>()
                for item in anyObj as! Array<AnyObject> {
                    let matItem = MatItem()
                    for (itemType, itemName) in item as! NSMutableDictionary {
                        if(itemType as! String == "stable_weight") {
                            matItem.itemWeight = itemName as! NSNumber
                        } else if(itemType as! String == "id") {
                            matItem.itemId = itemName as! NSNumber
                        } else if(itemType as! String == "item_name") {
                            matItem.itemName = itemName as! String
                        } else if(itemType as! String == "stable_weight_modified") {
                            matItem.itemWeighedDate = (itemName as! String)
                        } else if(itemType as! String == "container_weight") {
                            matItem.containerWeight = itemName as! NSNumber
                        } else if(itemType as! String == "num_units") {
                            matItem.numUnits = Float(itemName as! String)!
                        } else if(itemType as! String == "units") {
                            matItem.units = itemName as! String
                        } else if(itemType as! String == "max_weight") {
                            matItem.itemMaxWeight = itemName as! NSNumber
                        }
                    }
                    sectionArray.append(matItem)
//                    print(matItem.itemWeight,matItem.itemMaxWeight)
                    if(sectionArray.count == HomeViewController.MAX_ITEMS_IN_SECTION) {
                        self.listItems.append(sectionArray)
                        sectionArray.removeAll()
                    }
                }
                if(sectionArray.count > 0){
                    self.listItems.append(sectionArray)
                }
                self.refreshControl.endRefreshing()
                self.collectionView?.reloadData()
            } catch {
                NSLog("Serialization to String failed on reading. Using Test data")
                self.listItems = TestDataMatItems().testListItems
                self.collectionView?.reloadData()
            }
            let visualizerItem = MatItem()
            visualizerItem.itemId = 0
            visualizerItem.itemName = "matVisualizerCell"
            var matVisualizerSection = Array<MatItem>()
            matVisualizerSection.append(visualizerItem)
            self.listItems.insert(matVisualizerSection, atIndex: 0)
        })
    }

    func refresh(sender:AnyObject)
    {
        getScaleDataFromServer()
    }
    
    func onListButtonPressed(sender:AnyObject) {
        let listStoryBoard =  UIStoryboard(name: "ListTableStoryboard", bundle: nil)
        let vc = listStoryBoard.instantiateViewControllerWithIdentifier("ListTableViewController") as! ListTableViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Collection View
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return listItems.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numItems = listItems[section].count
        return numItems
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: HomeViewController.CELL_INSET,
                               left: HomeViewController.CELL_INSET,
                             bottom: HomeViewController.CELL_INSET,
                              right: HomeViewController.CELL_INSET)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/CGFloat(listItems[indexPath.section].count) - (2 * HomeViewController.CELL_INSET), height: 180)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellType = listItems[indexPath.section][indexPath.row].itemName
//        var cell = UICollectionViewCell()
        if(cellType == "matVisualizerCell") {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellType, forIndexPath: indexPath) as! MatVisualizerViewCell
            cell.drawItems(listItems)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("matDescriptorCell", forIndexPath: indexPath) as! MatItemViewCell
            cell.cellData = listItems[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInterimSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

}

