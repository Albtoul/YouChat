//
//  RegisterViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameField:UITextField!
    @IBOutlet weak var lastNameField:UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var profileImage:UIImageView!
    
    let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        roundedCorner()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPressed(_ sender:UIButton){
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty,
              password.count >= 6 else {
            return
        }
        
        spinner.show(in: view)
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self]
            _, error in
            
            guard error == nil else {
                print("Error : \(String(describing: error?.localizedDescription))")
                return
            }
            
            DispatchQueue.main.async {
                self?.spinner.dismiss()
            }
            
            UserDefaults.standard.setValue(email, forKey: "email")
            UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
            
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
}

extension RegisterViewController {
    func roundedCorner(){
        
        firstNameField.layer.cornerRadius = 12
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.masksToBounds = true
        
        lastNameField.layer.cornerRadius = 12
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.masksToBounds = true
        
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.masksToBounds = true
        
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.masksToBounds = true
        
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        
    }
}
