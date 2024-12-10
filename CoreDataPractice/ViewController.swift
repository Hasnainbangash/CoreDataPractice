//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Elexoft on 10/12/2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
    var item: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "phoneBookPicture2"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        
        // Get items from Core Data
        fetchPeople()
    }
    
    func fetchPeople() {
        do {
            self.item = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: "What is their name, age, gender and phoneNo?", preferredStyle: .alert)
        
        // Add text fields to the alert controller
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Age"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Gender"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter PhoneNo"
        }
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let nameTextField = alert.textFields![0]
            let ageTextField = alert.textFields![1]
            let genderTextField = alert.textFields![2]
            let phoneNoTextField = alert.textFields![3]
            
            // TODO: Create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = nameTextField.text
            newPerson.age = Int64(ageTextField.text ?? "Nil") ?? 0
            newPerson.gender = genderTextField.text
            newPerson.phoneNo = Int64(phoneNoTextField.text ?? "Nil") ?? 0
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
            
        }
        
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCellReuseableCell", for: indexPath) as! PersonCell
        let person = item![indexPath.row]
        cell.nameLabel.text = person.name
        cell.ageLabel.text = String(person.age)
        cell.genderLabel.text = person.gender
        cell.configureData(name: person.name!, age: person.age, gender: person.gender!, phoneNo: person.phoneNo)
        //        cell.alpha = 0.5
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = item![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Person", message: "Edit Details", preferredStyle: .alert)
        // Add text fields to the alert controller
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Age"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Gender"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter PhoneNo"
        }
        
        let nameTextField = alert.textFields![0]
        nameTextField.text = person.name
        
        let ageTextField = alert.textFields![1]
        ageTextField.text = String(person.age)
        
        let genderTextField = alert.textFields![2]
        genderTextField.text = person.gender
        
        let phoneNoTextField = alert.textFields![3]
        phoneNoTextField.text = String(person.phoneNo)
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let nameTextField = alert.textFields![0]
            let ageTextField = alert.textFields![1]
            let genderTextField = alert.textFields![2]
            let phoneNoTextField = alert.textFields![3]
            
            // TODO: Edit name property of person object
            person.name = nameTextField.text
            person.age = Int64(ageTextField.text ?? "Nil") ?? 0
            person.gender = genderTextField.text
            person.phoneNo = Int64(phoneNoTextField.text ?? "Nil") ?? 0
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        alert.addAction(saveButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            // TODO: Which person to remove
            let personToRemove = self.item![indexPath.row]
            
            // TODO: Remove the person
            self.context.delete(personToRemove)
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
}
