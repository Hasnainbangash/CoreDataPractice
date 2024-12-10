//
//  PersonCell.swift
//  CoreDataPractice
//
//  Created by Elexoft on 10/12/2024.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(name: String, age: Int64, gender: String, phoneNo: Int64) {
        self.nameLabel.text = "Name: " + name
        self.ageLabel.text = "Age: " + String(age)
        self.genderLabel.text = "Gender: " + gender
        self.phoneNumberLabel.text = "PhoneNo: " + String(phoneNo)
    }

}
