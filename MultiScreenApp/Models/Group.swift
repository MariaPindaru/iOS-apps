//
//  Group.swift
//  MultiScreenApp
//
//  Created by Maria Pindaru on 16.04.2023.
//

import Foundation

class Group {
    var members: [Person]!
    
    init(sourceFileName: String){
        let xmlParser = XMLPeopleParser(name: sourceFileName)
        xmlParser.parsing()
        self.members = xmlParser.peopleData
    }
    
    func getMember(index: Int) -> Person {
        return self.members[index]
    }
    
    func getCount() -> Int {
        return self.members.count
    }
}
