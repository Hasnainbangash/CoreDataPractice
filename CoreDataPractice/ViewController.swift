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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
    var item: [Person]?
    
    var differentNames: [String: [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        seperateOneValue(value: "F")
        seperateAllValues()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        // Changing the background image for the view in Table View
        tableView.backgroundView = UIImageView(image: UIImage(named: "phoneBookPicture2"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        
        // Get items from Core Data
        fetchPeople()
    }
    
    func fetchPeople() {
        do {
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.item = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func seperateOneValue(value: String) {
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let pred = NSPredicate(format: "name CONTAINS %@", value)
            request.predicate = pred
            self.item = try context.fetch(request)
            for i in item! {
                if differentNames[value] == nil {
                    differentNames[value] = []
                }
                differentNames[value]?.append(i.name ?? "Nil")
            }
        } catch let error {
            print(error.localizedDescription)
        }
        print(differentNames)
    }
    
    func seperateAllValues() {
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            self.item = try context.fetch(request)
            
            for person in item! {
                if let name = person.name, !name.isEmpty {
                    let firstLetter = String(name.prefix(1))/*.uppercased()*/
                    
                    if differentNames[firstLetter] == nil {
                        differentNames[firstLetter] = []
                    }

                    differentNames[firstLetter]?.append(name)
                }
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        print(differentNames)
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: "What is their name, age, gender and phoneNo?", preferredStyle: .alert)
        
        // Add text fields to the alert controller
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
            textField.autocapitalizationType = .words
            textField.keyboardType = .default
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Age"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Gender"
            textField.autocapitalizationType = .words
            textField.keyboardType = .default
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter PhoneNo"
            textField.keyboardType = .phonePad
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
            } catch let error {
                print(error.localizedDescription)
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
            
        }
        
        // Cancel Button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Button is pressed")
        }
        
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func filterContent(for searchText: String) {
        if searchText.isEmpty {
            fetchPeople()
        } else {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let pred = NSPredicate(format: "name CONTAINS %@", searchText)
            request.predicate = pred
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            do {
                self.item = try context.fetch(request)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterContent(for: searchBar.text ?? "")
        tableView.reloadData()
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
            textField.autocapitalizationType = .words
            textField.keyboardType = .default
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Age"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Gender"
            textField.autocapitalizationType = .words
            textField.keyboardType = .default
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter PhoneNo"
            textField.keyboardType = .phonePad
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
            } catch let error {
                print(error.localizedDescription)
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Button is pressed")
        }
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
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
            } catch let error {
                print(error.localizedDescription)
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
}
