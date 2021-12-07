//
//  ViewController.swift
//  WeatherApp
//
//  Created by user193659 on 11/29/21.
//

import UIKit
import Firebase

//Login
class ViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPersonContext()
        // Do any additional setup after loading the view.
    }


    //on login btn clicked
    @IBAction func loginBtnClicked(_ sender: Any) {
        //checking inputs pwd and email
        if let email = emailLabel.text , let pwd = passwordLabel.text, !email.isEmpty , !pwd.isEmpty
        {
            //performing signing using firebase api
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pwd, completion: {[weak self] result,error in
                
                //getting string self
                guard let strongSelf = self else{
                    return
                }
                //if any error ouccres then showing error
                guard error == nil else{
                    print("Error")
                    strongSelf.showErrorAlert()
                    return
                }
                //if login success then going to home screen
                let mapController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "home")
                //displaying homescreen full screen
                mapController?.modalPresentationStyle = .fullScreen
                //actually presenting the home screen
                strongSelf.present(mapController!, animated: true, completion: nil)
                
                //saving person data to context
                let person = Person(context: self!.context)
                
                person.personEmail = email
                person.personPassword = pwd
                
                //saving the context
                try! self?.context.save()
                
                print("Login success")
            })
        }
        else
        {
            showErrorAlert()
        }
        
    }
    
    //to show error
    func showErrorAlert()
    {
        //creating alert controller
        let alert = UIAlertController(title: "Data is invalid", message: "Please enter all data", preferredStyle: .alert)
        //adding alet action btn okay
        let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okay)
        //presenting alert
        present(alert, animated: true, completion: nil)
    }
    
    //delete all existing person coredata
    func checkPersonContext()
    {
        let persons = try! context.fetch(Person.fetchRequest())
        if( persons.count>0)
        {
            for person in persons
            {
                context.delete(person as! Person)
            }
            try! context.save()
        }
        else{
            print("Context value")
        }
    }
}

