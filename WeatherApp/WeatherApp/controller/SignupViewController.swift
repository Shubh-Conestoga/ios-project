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
        
        //cheking input data
        guard let email = emailText.text , !email.isEmpty else
        {
            ShowAlert(for:"Please enter an email")
            return
        }
        guard let pwd = pwdText.text , !pwd.isEmpty else
        {
            ShowAlert(for:"Please emter password of atleast 6 lettes")
            return
        }
        guard let cfPwd = reptPwdText.text, !cfPwd.isEmpty else
        {
            ShowAlert(for:"Please enter repeat password")
            return
        }
//        checking if repeat pwd and pwd is same
        guard cfPwd == pwd else
        {
            ShowAlert(for:"Please enter repeat password")
            return
        }
        
        //registering user using firebase api
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pwd, completion: {
            res,error in
            //if any error then showing the error
            guard error==nil else
            {
                self.ShowAlert(for: "Something went wrong!")
                
                return
            }
            //showing alert controller on register success
            let alertSuccess = UIAlertController(title:"Registration Success", message: "\(email) registred successfully! Please login for using our services!", preferredStyle: .alert)
            alertSuccess.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alertSuccess, animated: true, completion: nil)
        })
        
        
    }
    
    //for showing error using alertController
    func ShowAlert(for msg:String)
    {
        let alert = UIAlertController(title: "Invalid data", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
