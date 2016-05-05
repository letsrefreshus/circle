//
//  List.swift
//  circle
//
//  Created by Animish Gadve on 4/22/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//


import UIKit

class List: NSObject, ListItemProtocol {
    var listName = String()
    var listId = NSNumber()
    var listDateAdded = String()
    var isMainList = Bool()
    var serverCommunicator = ServerCommunication.sharedInstance
    var delegate : ListProtocol?
    
    var listItems = [ListItem]()
    
    override init() {
        super.init()
//        loadSampleItems()
        isMainList = false
        insertAddItemCell()
    }
    
    func loadSampleItems(){
        listItems += [ListItem(id: 1, name: "Eggs"), ListItem(id: 2, name: "Milk"), ListItem(id: 3, name: "Bread")];
    }
    
    func insertAddItemCell() {
        listItems.insert(ListItem(id: 0, name: ""), atIndex: listItems.count)
    }
    
    func insertUserEnteredItemToList(item:ListItem) {
        listItems.insert(item, atIndex: (self.listItems.count - 1))
        if self.delegate != nil {
            self.delegate!.populateList(self.listItems)
        }
        serverCommunicator.postDataToServer(ServerCommunication.ParametersForOperation.ListAddItem, headers: ServerCommunication.HeadersForOperation.ListAddItem, additionalParameters: ["list_id" : listId, "item_name":item.itemName, "isActive": false]) { (responseData) in
            print("Item added to the list on the server")
        }
    }
    
    func deleteItemFromList(index:NSInteger) {
        serverCommunicator.postDataToServer(ServerCommunication.ParametersForOperation.ListDeleteItem, headers: ServerCommunication.HeadersForOperation.ListDeleteItem, additionalParameters: ["list_id" : listId, "item_id":listItems[index].itemId]) { (responseData) in
            print("Item Deleted successfully")
        }
        self.listItems.removeAtIndex(index)
    }
    
    // MARK:-DELEGATE FOR HANDLING ADDED ITEM
    func addItemController(controller: ListTableViewCell, didAddItem: String) {
        insertUserEnteredItemToList(ListItem(id:0, name:didAddItem, isActive: false))
    }
    
    func sendEditsToItem(itemUpdated:ListItem) {
        for i in 0 ..< listItems.count {
            if listItems[i].itemId == itemUpdated.itemId {
                 listItems[i] = itemUpdated
                break
            }
        }
        serverCommunicator.postDataToServer(ServerCommunication.ParametersForOperation.ListEditItem, headers: ServerCommunication.HeadersForOperation.ListEditItem, additionalParameters: ["list_id" : listId, "item_id" : itemUpdated.itemId, "item_name":itemUpdated.itemName, "is_active": itemUpdated.isActive]) { (responseData) in
            print("Item edited in the list on the server")
        }
    }
    
    func getListItemDataFromServer() {
        serverCommunicator.postDataToServer(ServerCommunication.ParametersForOperation.ListItemsFetchData, headers: ServerCommunication.HeadersForOperation.ListItemsFetchData, additionalParameters: ["list_name":listName], completion:{
            (responseData:NSData) -> Void in
            do {
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(responseData, options:.MutableContainers)
                self.listItems.removeAll()
                self.insertAddItemCell()
                for item in anyObj as! Array<AnyObject> {
                    var id = NSNumber()
                    var name = String()
                    var isActive = Bool()
                    for (itemType, itemName) in item as! NSMutableDictionary {
//                        let data = ((itemName as? NSNumber) != nil) ? itemName.stringValue : itemName as! String
                        if(itemType as! String == "id") {
                            id = itemName as! NSNumber
                        } else if(itemType as! String == "item_name") {
                            name = itemName as! String
                        } else if (itemType as! String == "isActive") {
                            isActive = itemName as! Bool
                        }
                    }
                    self.listItems.insert(ListItem(id:id, name:name, isActive:isActive), atIndex: (self.listItems.count - 1));
                }
                if self.listItems.count > 0 && self.isMainList {
                    if self.delegate != nil {
                        self.delegate!.populateList(self.listItems)
                    }
                }
            } catch {
                NSLog("Serialization to String failed on reading")
            }
        })
    }
}