//
//  DetailsViewController.swift
//  MultiScreenApp
//
//  Created by Maria Pindaru on 17.04.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var memberNameLabel: UILabel!
    @IBOutlet weak var personDescriptionLabel: UILabel!
    
    var member: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.memberNameLabel.text = member.name
        self.personDescriptionLabel.text = member.description
    }
    
    @IBAction func seeWebInfo(_ sender: Any) {
        performSegue(withIdentifier: "ToWebVC", sender: self.member)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! WebViewController
        destinationViewController.member = sender as? Person
    }

}
