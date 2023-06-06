//
//  CheckTableViewCell.swift
//  CoreDataApp
//
//  Created by Maria Pindaru on 01.06.2023.
//

import UIKit

protocol CheckTableViewCellDelegate: AnyObject {
  func checkTableViewCell(_ cell: CheckTableViewCell, didChagneCheckedState checked: Bool)
}

class CheckTableViewCell: UITableViewCell {
    
    var task: Task!

    @IBOutlet weak var checkbox: Checkbox!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var details: UILabel!
    
    weak var delegate: CheckTableViewCellDelegate?

    @IBAction func checked(_ sender: Any) {
        updateChecked()
        delegate?.checkTableViewCell(self, didChagneCheckedState: checkbox.checked)
    }

    func set(task: Task) {
        self.task = task
        label.text = task.title
        details.text = task.details
        set(checked: task.done)
     }
     
     func set(checked: Bool) {
       checkbox.checked = checked
       updateChecked()
     }
     
     private func updateChecked() {
       let attributedString = NSMutableAttributedString(string: label.text!)
       
       if checkbox.checked {
         attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
       } else {
         attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
       }
       
       label.attributedText = attributedString
     }
}

