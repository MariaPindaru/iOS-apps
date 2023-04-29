//
//  XMLGroupPaarser.swift
//  MultiScreenApp
//
//  Created by Maria Pindaru on 16.04.2023.
//

import Foundation


class XMLPeopleParser:NSObject, XMLParserDelegate{
    
    var name : String
    init(name:String){self.name = name}
    
    // tmp vars for parsed data
    var pName, pBirthDate, pPlaceOfBirth, pImage, pWebPageURL, pDescription : String!
    var pSigned: Int?
    var pAppearances: Int!
    
    // vars to spy
    var elementId = -1
    var passData  = false
    
    // vars for data
    var peopleData = [Person]()
    var personData : Person!
    
    // parser
    var parser : XMLParser!
    
    let tags = ["name", "birthDate", "placeOfBirth", "signed", "appearances", "description", "image", "webPageURL"]
    
    // delegate methods for parsing
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // set the spy vars based on elementName
        if tags.contains(elementName){
            passData = true
            elementId = tags.firstIndex(of: elementName)!
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // place string to the right pVars
        if pDescription == nil {
            pDescription = ""
        }
        switch elementId{
            case 0 : pName         = string
            case 1 : pBirthDate    = string
            case 2 : pPlaceOfBirth = string
            case 3 : pSigned       = Int(string) ?? 0
            case 4 : pAppearances  = Int(string)
            case 5 : pDescription  = pDescription + string
            case 6 : pImage        = string
            case 7 : pWebPageURL   = string
            default: break
        }
    }
        
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // reset the spys
        passData  = false; elementId = -1;
        
        // if person then make an object for peopleData
        if elementName == "person"{
            personData = Person(name: pName,
                                birthDate: pBirthDate,
                                placeOfBirth: pPlaceOfBirth,
                                signed: pSigned,
                                appearances: pAppearances,
                                description: pDescription,
                                image: pImage,
                                webPageURL: pWebPageURL)
            peopleData.append(personData)
            
            // prepare for next person
            self.resetData()
        }
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
    
    func resetData(){
        pName         = nil
        pBirthDate    = nil
        pPlaceOfBirth = nil
        pSigned       = nil
        pAppearances  = nil
        pDescription  = nil
        pImage        = nil
        pWebPageURL   = nil

    }
    
}
