//
//  GroupsVC.swift
//  CoreDataApp
//
//  Created by Maria Pindaru on 30.05.2023.
//

import UIKit
import CoreData

class GroupsVC: BaseTableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // make the frc fetcher
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.performFetch()
        
        if frc.fetchedObjects!.count == 0{ // init from xml file
            let xmlParser = XMLGroupsParser(name: "data.xml", context: self.context)
            xmlParser.parsing()
            self.saveData()
            self.performFetch()
        }
        
        // deal with frc delegate
        frc.delegate = self
    }
    
    func fetchRequest()->NSFetchRequest<NSFetchRequestResult>{
        // construct the request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        
        // define how you sort
        let sort = NSSortDescriptor(key: "title", ascending: true)
                
        request.sortDescriptors = [sort]
        
        return request
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.fetchedObjects!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        let groupData = frc.object(at: indexPath) as! Group
        cell.textLabel?.text = groupData.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGroup: Group = frc.object(at: indexPath) as! Group
        performSegue(withIdentifier: "ToGroupTasksVC", sender: selectedGroup)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! GroupTasksVC
        destinationViewController.group = sender as? Group
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let groupToDelete: Group = frc.object(at: indexPath) as! Group
            self.context.delete(groupToDelete)
            self.updateTableData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Rename") { (_, _, completionHandler) in
            let groupToUpdate: Group = self.frc.object(at: indexPath) as! Group
            self.updateGroup(group: groupToUpdate)
            completionHandler(false)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            let groupToDelete: Group = self.frc.object(at: indexPath) as! Group
            self.context.delete(groupToDelete)
            self.saveData()
            self.updateTableData()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    @IBAction func addGroup(_ sender: Any) {
        let alert = UIAlertController(title: "Add new tasks group", message: "Type the group name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter group title"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let submitButton = UIAlertAction(title: "Add", style: .default){
            (action) in
            
            let textField = alert.textFields![0]
            
            // create data
            let entity: NSEntityDescription! = NSEntityDescription.entity(forEntityName: "Group", in: self.context)
            let newGroup = Group(entity: entity, insertInto: self.context)
            newGroup.title = textField.text
            
            self.saveData()
            
            self.updateTableData()
        }
        
        alert.addAction(submitButton)
        submitButton.isEnabled = false
        self.currentAlerAction = submitButton
        
        self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
    }
    
    func updateGroup(group: Group){
        let alert = UIAlertController(title: "Update tasks group", message: "Type the group name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter group title"
            textField.text = group.title
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let submitButton = UIAlertAction(title: "Update", style: .default){
            (action) in
            
            let textField = alert.textFields![0]
            
            // update data
            group.title = textField.text
            
            self.saveData()
            
            self.updateTableData()
        }
        
        alert.addAction(submitButton)
        self.currentAlerAction = submitButton
        
        self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
    }
    
}
