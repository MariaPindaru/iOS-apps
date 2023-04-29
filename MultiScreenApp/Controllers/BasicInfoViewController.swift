//
//  BasicInfoViewController.swift
//  MultiScreenApp
//
//  Created by Maria Pindaru on 16.04.2023.
//

import UIKit

class BasicInfoViewController: UIViewController {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var signedLabel: UILabel!
    @IBOutlet weak var appearancesLabel: UILabel!
    
    var member: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.memberNameLabel.text = member.name
        self.imageView.image = UIImage(named : member.image)
        self.birthDateLabel.text = member.birthDate
        self.placeOfBirthLabel.text = member.placeOfBirth
        self.signedLabel.text = member.signed != nil ? String(member.signed!) : "-"
        self.appearancesLabel.text = String(member.appearances)
    }
    

    @IBAction func seeMoreDetails(_ sender: UIButton) {
        performSegue(withIdentifier: "ToDetailsVC", sender: self.member)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! DetailsViewController
        destinationViewController.member = sender as? Person
    }
}
