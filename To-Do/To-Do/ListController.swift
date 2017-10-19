//
//  ListController.swift
//  To-Do
//
//  Created by Alasdair Lincoln on 12/10/2017.
//  Copyright © 2017 Alasdair Lincoln. All rights reserved.
//

import UIKit

class ListController: UITableViewController {

    var items:[String] = ["Bread","Butter"]
    
    @IBAction func showDialog(_ sender: UIBarButtonItem) {
        
        let title = NSLocalizedString("New Item", comment: "an item is something to add to the list")
        let message = NSLocalizedString("Type item below", comment: "instructions on how to enter a new item")
        let addTitle = NSLocalizedString("Add", comment: "label on button to add the new item")
        let cancelTitle = NSLocalizedString("Cancel", comment: "label on button used to cancel and dismiss the dialog")
        
        let alert = UIAlertController(title: "New Item", message: "Type item below", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let textFields = alert.textFields{
                if let item = textFields[0].text {
                    self.items.append(item)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.saveList()
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
        if self.isEditing {
            sender.title = "Done"
        } else {
            sender.title = "Edit"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell:UITableViewCell = self.tableView?.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let savedItems = UserDefaults.standard
        if let loadedItems:[String] = savedItems.object(forKey: "items") as! [String]?{
            self.items = loadedItems
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func saveList() {
        let savedItems = UserDefaults.standard
        savedItems.set(items, forKey: "items")
        savedItems.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)

        if let label = cell.textLabel {
            label.text = self.items[indexPath.row]            
        }
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.items.remove(at: indexPath.row)
            self.saveList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let item:String = items[fromIndexPath.row]
        self.items.remove(at: fromIndexPath.row)
        items.insert(item, at: to.row)
        self.saveList()
        self.tableView.reloadData()
    }
 
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
