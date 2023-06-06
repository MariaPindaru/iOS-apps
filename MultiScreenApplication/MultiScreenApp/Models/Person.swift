//
//  Person.swift
//  MultiScreenApp
//
//  Created by Maria Pindaru on 16.04.2023.
//

import Foundation

class Person {
    var name, birthDate, placeOfBirth, image, webPageURL, description : String!
    var signed: Int?
    var appearances: Int!
    
    init(name: String!, birthDate: String!, placeOfBirth: String!, signed: Int?, appearances: Int!, description: String!, image: String!, webPageURL: String!) {
        self.name = name
        self.birthDate = birthDate
        self.placeOfBirth = placeOfBirth
        self.signed = signed
        self.appearances = appearances
        self.description = description
        self.image = image
        self.webPageURL = webPageURL
    }
}
