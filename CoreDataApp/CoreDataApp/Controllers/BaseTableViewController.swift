//
//  BaseCoreDataCotroller.swift
//  CoreDataApp
//
//  Created by Maria Pindaru on 03.06.2023.
//

import UIKit
import CoreData

class BaseTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
        
    // Core Data related
    
    var frc : NSFetchedResultsController<NSFetchRequestResult>!
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func updateTableData(){
        self.performFetch()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func performFetch(){
        do{
            try self.frc.performFetch()
        }catch{
            print("cannot fetch")
        }
    }
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("cannot save changes")
        }
    }
    
    // Alert popup related
    
    var currentAlerAction: UIAlertAction!

    @objc func textFieldDidChange(_ field: UITextField) {
        self.currentAlerAction.isEnabled = field.text?.count ?? 0 > 0 // disable action if any textfield is empty
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil) // close popup if background is tapped
    }
}
