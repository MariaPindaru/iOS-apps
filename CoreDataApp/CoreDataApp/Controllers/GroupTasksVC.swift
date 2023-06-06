//
//  GroupTasksVC.swift
//  CoreDataApp
//
//  Created by Maria Pindaru on 30.05.2023.
//

import UIKit
import CoreData

class GroupTasksVC: BaseTableViewController, CheckTableViewCellDelegate {
    var group: Group!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make the frc fetcher
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.performFetch()
        
        frc.delegate = self

    }
    
    func fetchRequest()->NSFetchRequest<NSFetchRequestResult>{
        // construct the request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        // fetch only the tasks from the selected group
        request.predicate = NSPredicate(format: "group == %@", self.group as CVarArg)
        
        // define sort
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! CheckTableViewCell
           
        cell.delegate = self
           
        let todo: Task =  frc.object(at: indexPath) as! Task
        cell.set(task: todo)
           
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let taskToDelete: Task = frc.object(at: indexPath) as! Task
            self.context.delete(taskToDelete)
            self.saveData()
            self.updateTableData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            let taskToUpdate: Task = self.frc.object(at: indexPath) as! Task
            self.updateTask(selectedTask: taskToUpdate)
            completionHandler(false)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            let taskToDelete: Task = self.frc.object(at: indexPath) as! Task
            self.context.delete(taskToDelete)
            self.saveData()
            self.updateTableData()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    @IBAction func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "Add new task", message: "Type the task name and description", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter task title"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        } // title
        alert.addTextField { (textField) in
            textField.placeholder = "Enter task details"
        }// description
        
        let submitButton = UIAlertAction(title: "Add", style: .default){
            (action) in
            
            let titleField = alert.textFields![0]
            let descriptionField = alert.textFields![1]
            
            // create data
            let entity: NSEntityDescription! = NSEntityDescription.entity(forEntityName: "Task", in: self.context)
            let newTask = Task(entity: entity, insertInto: self.context)
            newTask.title = titleField.text
            newTask.details = descriptionField.text
            newTask.done = false
            newTask.group = self.group
            
            self.saveData()
            
            self.updateTableData()
        }
        
        submitButton.isEnabled = false
        alert.addAction(submitButton)
        self.currentAlerAction = submitButton
        
        self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
    }
    
    func updateTask(selectedTask: Task) {
        let alert = UIAlertController(title: "Update task", message: "Type the task name and description", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter task title"
            textField.text = selectedTask.title
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        } // title
        alert.addTextField { (textField) in
            textField.placeholder = "Enter task details"
            textField.text = selectedTask.details
        }// description
        
        let submitButton = UIAlertAction(title: "Update", style: .default){
            (action) in
            
            let titleField = alert.textFields![0]
            let descriptionField = alert.textFields![1]
            
            // update data
            selectedTask.title = titleField.text
            selectedTask.details = descriptionField.text
            
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
    
    func checkTableViewCell(_ cell: CheckTableViewCell, didChagneCheckedState checked: Bool) {
        let taskToUpdate: Task = cell.task
        taskToUpdate.done = checked
        self.saveData()
    }
    
}
