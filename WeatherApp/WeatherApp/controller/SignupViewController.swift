//
//  SignupViewController.swift
//  WeatherApp
//
//  Created by user193659 on 12/4/21.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet weak var reptPwdText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func signupBtnClicked(_ sender: Any) {
        
        guard let email = emailText.text , !email.isEmpty else
        {
            showAlert(for:"Please enter an email")
            return
        }
        guard let pwd = pwdText.text , !pwd.isEmpty else
        {
            showAlert(for:"Please emter password of atleast 6 lettes")
            return
        }
        guard let cfPwd = reptPwdText.text, !cfPwd.isEmpty else
        {
            showAlert(for:"Please enter repeat password")
            return
        }
        guard cfPwd == pwd else
        {
            showAlert(for:"Please enter repeat password")
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pwd, completion: {
            res,error in
            guard error==nil else
            {
                self.showAlert(for: "Something went wrong!")
                
                return
            }
            let alertSuccess = UIAlertController(title:"Registration Success", message: "\(email) registred successfully! Please login for using our services!", preferredStyle: .alert)
            alertSuccess.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alertSuccess, animated: true, completion: nil)
        })
        
        
    }
    
    func showAlert(for msg:String)
    {
        let alert = UIAlertController(title: "Invalid data", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
