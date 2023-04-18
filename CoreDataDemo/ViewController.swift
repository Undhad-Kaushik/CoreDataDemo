//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by undhad kaushik on 11/02/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var salaryTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var arrTeacher: [TeacherDetails] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func saveData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let teacherEntity = NSEntityDescription.entity(forEntityName: "Teacher", in: viewContext)!
        let tearcherMenagedObject = NSManagedObject(entity: teacherEntity, insertInto: viewContext)
        tearcherMenagedObject.setValue(nameTextField.text ?? "", forKey: "name")
        tearcherMenagedObject.setValue(addressTextField.text ?? "", forKey: "address")
        tearcherMenagedObject.setValue(Double(salaryTextField.text ?? "0"), forKey: "salary")
        
        do {
            try viewContext.save()
            
            displayAlert(message: "Data saved successfully")
            nameTextField.text = ""
            addressTextField.text = ""
            salaryTextField.text = ""
        } catch let error as NSError{
            print(error.localizedDescription)
            displayAlert(message: error.localizedDescription)
        }
        
    }
    private func getTeacherDetailsSearch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Teacher")
        
        do {
            let students = try viewContext.fetch(fetchRequest)
            arrTeacher = []
            for student in students as! [NSManagedObject] {
                
                let name = student.value(forKey: "name") ?? ""
                let address = student.value(forKey: "address") ?? ""
                let salary = student.value(forKey: "salary") ?? 0.0
                let teacherObject = TeacherDetails(name: name as! String, address: address as! String, salary: salary as! Double)
                arrTeacher.append(teacherObject)
                print("student name is \(name)")
                print("student address is \(address)")
                print("student salary is \(salary)")
                displayAlert(message: "Data seaerching successfully")

            }
            print(arrTeacher)
            if arrTeacher.count > 0 {
                
            }
            else {
                print("no data found")
            }
        } catch let error as NSError {
            
        }
    }
    
    
    private func searchData(){
        getTeacherDetailsSearch()
        
    }
    
    private func updateData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Teacher")
        fetchRequest.predicate = NSPredicate(format: "name = %@", nameTextField.text ?? 0.0)
        do {
            let students = try viewContext.fetch(fetchRequest)
            for student in students as! [NSManagedObject] {
                let tempStudent = student
                tempStudent.setValue(Double(salaryTextField.text ?? "0"), forKey: "salary")
                try viewContext.save()
                print("Data Updated SuccessFully.")
                displayAlert(message: "Data Updated Successfuly")
//                nameTextField.text = ""
//                addressTextField.text = ""
//                salaryTextField.text = ""
                getTeacherDetailsSearch()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            displayAlert(message: error.localizedDescription)
        }
        
    }
    
    private func deleteData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Teacher")
        fetchRequest.predicate = NSPredicate(format: "salary = %f", Float(salaryTextField.text ?? "0.0") ?? 0.0)
       // fetchRequest.predicate = NSPredicate(format: "name = %@", nameTextField.text ?? 0.0)
        
        do {
            let students = try viewContext.fetch(fetchRequest)
            for student in students as! [NSManagedObject]{
                viewContext.delete(student)
                try viewContext.save()
                print("Data deleted successFully.")
                displayAlert(message: "Data deleted successfully")
                nameTextField.text = ""
                addressTextField.text = ""
                salaryTextField.text = ""
                getTeacherDetailsSearch()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            displayAlert(message: error.localizedDescription)
            
        }
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if nameTextField.text == "" || addressTextField.text == "" || salaryTextField.text == "" {
            displayAlert(message: "Please all details insert")
        }
        saveData()
        
    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if nameTextField.text == "" || addressTextField.text == "" || salaryTextField.text == "" {
            displayAlert(message: "Please all details insert")
        }
        searchData()
        
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if nameTextField.text == "" || addressTextField.text == "" || salaryTextField.text == "" {
            displayAlert(message: "Please all details insert")
        }
        updateData()
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if nameTextField.text == "" || addressTextField.text == "" || salaryTextField.text == "" {
            displayAlert(message: "Please all details insert")
        }
        deleteData()
        
    }
    
    
    private func displayAlert(message: String){
        
        let alert: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okButton: UIAlertAction = UIAlertAction(title: "Ok", style: .default){ button in
            
            print("Ok button tapped")
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}



struct TeacherDetails {
    var name: String
    var address: String
    var salary: Double
}
