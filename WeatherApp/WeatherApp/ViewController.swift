//
//  ViewController.swift
//  WeatherApp
//
//  Created by user193659 on 11/29/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }


    @IBAction func loginBtnClicked(_ sender: Any) {
        if let email = emailLabel.text , let pwd = passwordLabel.text, !email.isEmpty , !pwd.isEmpty
        {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pwd, completion: {[weak self] result,error in
                
                guard let strongSelf = self else{
                    return
                }
                guard error == nil else{
                    print("Error")
                    strongSelf.showErrorAlert()
                    return
                }
                let mapController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "home")
                mapController?.modalPresentationStyle = .fullScreen
                strongSelf.present(mapController!, animated: true, completion: nil)
                print("Login success")
            })
        }
        else
        {
           
        }
    }
    
    func showErrorAlert()
    {
        let alert = UIAlertController(title: "Data is invalid", message: "Please enter all data", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
    }
}

