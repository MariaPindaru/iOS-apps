//
//  XMLGroupsParser.swift
//  CoreDataApp
//
//  Created by Maria Pindaru on 31.05.2023.
//

import UIKit
import CoreData

class XMLGroupsParser : NSObject, XMLParserDelegate{
    
    var context: NSManagedObjectContext
    
    var name : String
    init(name:String, context: NSManagedObjectContext){
        self.name = name
        self.context = context
    }
    
    // tmp vars for parsed data
    var pGroupTitle: String! = ""
    var pTaskTitle: String! = ""
    var pTaskDetails: String! = ""
    var pTaskIsDone: Bool! = false
    
    // vars for data
    var groupsData = [Group]()
    var tasksData = [Task]()
    var groupData : Group?
    var taskData : Task?
    
    // parser
    var parser : XMLParser!
    var currentElement: String? = ""
    
    // delegate methods for parsing
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "group" {
            groupData = Group(context: self.context)
        } else if elementName == "task" {
            taskData = Task(context: self.context)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString == ""{
            return
        }
        
        switch currentElement {
         case "groupTitle":
                pGroupTitle += trimmedString
        case "taskTitle":
                pTaskTitle += trimmedString
         case "details":
             pTaskDetails += trimmedString
         case "done":
             if trimmedString.lowercased() == "true" {
                 pTaskIsDone = true
             } else {
                 pTaskIsDone = false
             }
         default:
             break
         }
    }
        
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "group" {
            groupData?.title = pGroupTitle
            groupData?.tasks = NSSet(array: tasksData)
            
            groupsData.append(groupData!)
            
            resetGroupData()
            
        } else if elementName == "task" {
            taskData?.title = pTaskTitle
            taskData?.details = pTaskDetails
            taskData?.done = pTaskIsDone
            
            tasksData.append(taskData!)
            
            resetTaskData()
        }
    }
    
    func resetTaskData(){
        pTaskTitle = ""
        pTaskDetails = ""
        pTaskIsDone = false
        
        taskData = nil
    }
    
    func resetGroupData(){
        pGroupTitle = ""
        tasksData.removeAll()
        
        groupData = nil
    }
    
    func parsing(){
        // get the file
        let bundleUrl = Bundle.main.bundleURL
        let fileUrl   = URL(string: self.name, relativeTo: bundleUrl)
                
        // make the parser
        parser = XMLParser(contentsOf: fileUrl!)
        
        // parse
        parser.delegate = self
        parser.parse()
    }
    
}
