//
//  FoodItemSearch.swift
//  Assign4
//
//  Created by josh on 2018-11-28.
//  Copyright © 2018 SICT. All rights reserved.
//

import UIKit


protocol FoodItemSearchListDelegate: class {
    
    func selectTaskDidCancel(_ controller: UIViewController)
    
    func selectTask(_ controller: UIViewController, didSelect item: NdbSearchListItem)
}


class FoodItemSearchList: UITableViewController {
    
    // MARK: - Instance

    weak var delegate: FoodItemSearchListDelegate?
    
    var m: DataModelManager?
    
    var result: NdbSearchPackage?
    
    var searchTerm: String!
    
    // MARK: - Outlets
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem.title! = "Food item search"
        
        let key: String! = m!.ndbSearchPackage_GetByName(searchTerm!)
        
        // Listen for a notification that new data is available for the list
        NotificationCenter.default.removeObserver(self, name: Notification.Name(key), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name(key), object: nil)
    }
    
    // Method that runs when the notification happens
    @objc func reloadTableView() {
        result = m!.ndbSearchPackage!
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Call into the delegate
        delegate?.selectTaskDidCancel(self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return result?.list?.item?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = result!.list!.item![indexPath.row].name

        return cell
    }
    
    // Responds to a row selection event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < result!.list!.item!.count {
            
            // Fetch the data for the selected item
            let data = result!.list!.item![indexPath.row]
            
            // Call back into the delegate
            delegate?.selectTask(self, didSelect: data)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
