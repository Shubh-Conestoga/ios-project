//
//  ProfileViewController.swift
//  WeatherApp
//
//  Created by user199008 on 12/4/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    //geting the context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persons:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetching persons data using coredata
        fetchPersonDtls()
    }
    
    func fetchPersonDtls()
    {
        //fetching the core data and setting last's person's email to user email
        persons = try! context.fetch(Person.fetchRequest())
        self.emailLabel.text = persons.last?.personEmail
    }
    
    //deleting data from coredata
    func deleteDtls()
    {
        //deleting the person data
        self.context.delete(persons.first!)
        try! self.context.save()
    }
    
    //whenever logout btn clicked
    @IBAction func logOutBtnClicked(_ sender: Any) {
        //deleting the person data from coredata and going to the signin screen/ performing the segue
        deleteDtls()
        performSegue(withIdentifier: "logout", sender: self)
    }
}
